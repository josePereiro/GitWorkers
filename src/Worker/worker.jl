const _GW_WORKER_FILE_NAME = "gitworker.toml"
const _GW_WORKER_FILE_SYSROOT_KEY = "sys_root"
const _GW_WORKER_FILE_REMOTE_URL_KEY = "remote_url"

_worker_file(gwdir::String) = joinpath(gwdir, _GW_WORKER_FILE_NAME)
_worker_file(gw::GitWorker) = _worker_file(worker_root(gw))

function _write_worker_file(gw::GitWorker) 
    wdict = Dict{String, String}()
    wdict[_GW_WORKER_FILE_SYSROOT_KEY] = sys_root(gw)
    wdict[_GW_WORKER_FILE_REMOTE_URL_KEY] = remote_url(gw)
    wfile = _worker_file(gw)
    _mkdir(wfile)
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

function _load_worker(dir::String)
    !isdir(dir) && return nothing
    gwtoml = _worker_file(dir)
    !isfile(gwtoml) && return nothing
    return _gw_from_toml(gwtoml)
end

function _setup_worker(gw::GitWorker)

    # write gitworker.toml
    _write_worker_file(gw)

    # init gitlink
    gl = gitlink(gw)
    url = remote_url(gw)
    conn_test = GitLinks.instantiate(gl; verbose = false)
    conn_test ?
        @info("Worker connected", url) :
        @error("GitLink init fail (run 'git ls-remote <remote_url>' for testing connection)\nremote_url:$(url)")

    return gw
end


function _setup_worker(; sys_root = _GW_SYSTEM_DFLT_ROOT, url::String) 
    gw = GitWorker(;sys_root, remote_url = url)
    _setup_worker(gw::GitWorker)
end