const _GITWR_LOGS_RTDIR = ".rtlogs"
_out_rtlogfile(rtid) = _localdir(_GITWR_LOGS_RTDIR, string(rtid, ".out.log"))
_err_rtlogfile(rtid) = _localdir(_GITWR_LOGS_RTDIR, string(rtid, ".err.log"))

# ------------------------------------------------------------------
function eval_rt(rtfile)

    rtcmd = deserialize(rtfile)
    
    sysroot = _get_root()
    url = _get_url()
    rtid = rtcmd.id

    cached_rtfile = _localver(rtfile) # This will be deleted on execution
    _gwcp(rtfile, cached_rtfile)

    outfile = _out_rtlogfile(rtid)
    errfile = _err_rtlogfile(rtid)
    scriptfile = joinpath(@__DIR__, "routine_script.jl")

    if rtcmd.long

        julia = Base.julia_cmd()
        jlcmd = Cmd(`$julia --startup-file=no -- $(scriptfile) $(sysroot) $(url) $(cached_rtfile) $(rtid)`; detach = false)
        # jlcmd = pipeline(jlcmd; stdout = outfile, stderr = errfile, append = true)
        jlcmd = pipeline(jlcmd; stdout = outfile, stderr = outfile, append = true)
        run(jlcmd; wait = false)
        _gwrm(rtfile)

    else
        flag = GitWorkers.eval(rtcmd.rtexpr)
        return flag
    end
end


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
            flag = eval_rt(rtfile)
            flag === :EXIT && return
        
        catch err
            err isa InterruptException && rethrow()
            @warn("ERROR", err)
            rethrow(err) # Test
        end
    end
end
