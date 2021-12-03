const _GW_WORKER_FILE_NAME = "gitworker.toml"
const _GW_WORKER_FILE_SYSROOT_KEY = "sys_root"
const _GW_WORKER_FILE_REMOTE_URL_KEY = "remote_url"

_worker_file(gwdir::String) = joinpath(gwdir, _GW_WORKER_FILE_NAME)
_worker_file(gw::GitWorker) = _worker_file(worker_dir(gw))

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

function _gw_from_toml(gwfile::String)
    gdat = _read_toml(gwfile)
    sys_root = get(gdat, _GW_WORKER_FILE_SYSROOT_KEY, "")
    remote_url = get(gdat, _GW_WORKER_FILE_REMOTE_URL_KEY, "")
    (isempty(sys_root) || isempty(remote_url)) && return nothing
    return GitWorker(;sys_root, remote_url)
end