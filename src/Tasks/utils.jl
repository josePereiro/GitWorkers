## ---------------------------------------------------------------
function _reg_files_todel(path, paths...)
    file = _localdir(".todel", string(_gen_id(), ".todel"))
    allpaths = String[_native_urlpath(path)]
    for path_ in paths
        push!(allpaths, _native_urlpath(path_))
    end
    serialize(file, allpaths)
end

function _clear_todel_files()
    todeldir = _localdir(".todel")
    !isdir(todeldir) && return

    for todelfile in _gw_readdir(todeldir; join = true)
        !endswith(todelfile, ".todel")  && continue
        paths = deserialize(todelfile)
        for path in paths
            _gwrm.(path)
        end
        _gwrm.(todelfile)
    end

end

## ---------------------------------------------------------------
function _reg_for_seek_and_destroy(id, ids...)
    sdfileid = _gen_id()
    sdfile = _localdir(".seek_and_destroy", string(sdfileid, ".seek_and_destroy"))

    allids = String[string(id)]
    for id_ in ids
        push!(allids, string(id_))
    end
    push!(allids, sdfileid) # itself

    serialize(sdfile, allids)
end

## ---------------------------------------------------------------
function _clear_seek_and_destroy(; exit = false)
    sddir = _localdir(".seek_and_destroy")
    !isdir(sddir) && return

    for sdfile in _gw_readdir(sddir; join = true)
        !endswith(sdfile, ".seek_and_destroy")  && continue
        ids = deserialize(sdfile)
        for id in ids
            _walkdown_urldir() do path
                contains(path, id) && _gwrm.(path)
            end
        end
        _gwrm.(sdfile)
    end
    return exit ? (:EXIT, nothing) : nothing
end

## ---------------------------------------------------------------
const _GITWR_RTDATA_DIR = ".rtdat"
_rtdata_file(taskid, name) = _localdir(_GITWR_RTDATA_DIR, string(taskid, ".", name))

_save_rtdata(taskid, name, dat) = serialize(_rtdata_file(taskid, name), dat)
_load_rtdata(taskid, name, dfl = nothing) = 
    (fn = _rtdata_file(taskid, name); isfile(fn) ? deserialize(fn, dat) : dfl)

## ---------------------------------------------------------------
function _clear_rts()
    _uprepo_rtdir = _repodir(_GITWR_UPREPO_RTDIR)
    _uplocal_rtdir = _repodir(_GITWR_UPLOCAL_RTDIR)
    _gwrm.(_uprepo_rtdir)
    _gwrm.(_uplocal_rtdir)
end

## ---------------------------------------------------------------
macro _rtid()
    quote
        $(esc(:(__routine__.id)))
    end
end

macro _rt_rtfile()
    quote
        $(esc(:(__routine__.rtfile)))
    end
end

## ---------------------------------------------------------------
