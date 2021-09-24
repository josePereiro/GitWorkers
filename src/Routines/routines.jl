## ------------------------------------------------------------------
const _GITWR_ROUTINE_FILE_EXT = ".gwrt"
const _GITWR_UPLOCAL_RTDIR = ".uplocal_rtdir"
const _GITWR_UPREPO_RTDIR = ".uprepo_rtdir"

_is_rtfile(rtfile) = isfile(rtfile) && endswith(rtfile, _GITWR_ROUTINE_FILE_EXT)
_uplocal_rtfile(name) = _repodir(_GITWR_UPLOCAL_RTDIR, string(name, _GITWR_ROUTINE_FILE_EXT))
_uprepo_rtfile(name) = _repodir(_GITWR_UPREPO_RTDIR, string(name, _GITWR_ROUTINE_FILE_EXT))

# ------------------------------------------------------------------
function _serialize_rt(rtid, rtfile, ex::Expr)
    
    !Meta.isexpr(ex, :block) && error("A 'begin' block was expected. Ex: '@gitworker begin println(\"Hi\")' end")
    
    __routine__ = (;id = rtid, file = _rel_urlpath(rtfile))
    
    funsym = Symbol(:_routine, rtid)
    expr = quote
        function $(funsym)()

            __routine__ = $(__routine__)

            $(ex) 

            return nothing
        end
        $(funsym)()
    end
    
    serialize(rtfile, expr)

    # now push
    :(nothing)
end

_serialize_repo_rt(rtid, expr::Expr) = _serialize_rt(rtid, _uprepo_rtfile(rtid), expr)
_serialize_repo_rt(expr::Expr) = _serialize_repo_rt(_gen_id(), expr)

_serialize_local_rt(rtid, expr::Expr) = _serialize_rt(rtid, _uplocal_rtfile(rtid), expr)
_serialize_local_rt(expr::Expr) = _serialize_local_rt(_gen_id(), expr)


# ------------------------------------------------------------------
# TODO: make a system that allows to run just a partial set of routines
# but remembers the next time and 'ensures' all routines are finally run.
# This is to prevent an overtimed execution
function _eval_routines(rtdir)
    !isdir(rtdir) && return
    rtfiles = readdir(rtdir; join = true, sort = false)
    sort!(rtfiles; rev = true, by = mtime)

    for rtfile in rtfiles
        !_is_rtfile(rtfile) && continue

        try
            rtexpr = deserialize(rtfile)
            flag = Main.eval(rtexpr)
            flag === :EXIT && return
        
        catch err
            err isa InterruptException && rethrow()
            @warn("ERROR", err)
        end
    end
end
