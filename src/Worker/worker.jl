const _GW_WORKER_FILE_NAME = "gitworker.toml"
const _GW_WORKER_FILE_SYSROOT_KEY = "sys_root"
const _GW_WORKER_FILE_REMOTE_URL_KEY = "remote_url"

_worker_file(gw::GitWorker) = joinpath(worker_dir(gw), _GW_WORKER_FILE_NAME)

function _write_worker_file(gw::GitWorker) 
    wdict = Dict{String, String}()
    wdict[_GW_WORKER_FILE_SYSROOT_KEY] = sys_root(gw)
    wdict[_GW_WORKER_FILE_REMOTE_URL_KEY] = remote_url(gw)
    wfile = _worker_file(gw)
    return _write_toml(wfile, wdict)
end

function _find_worker_file(path)
    @show path
    if isdir(path) # Base
        wfile = joinpath(path, _GW_WORKER_FILE_NAME)
        isfile(wfile) && return wfile
    end
    
    dir = dirname(path)
    (dir == path) && return "" # Base
    return _find_worker_file(dir)
end