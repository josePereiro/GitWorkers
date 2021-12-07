struct GitWorker <: AbstractWorker
    # GW stuff
    sys_root::String
    remote_url::String

    # AbstractWorker
    worker_root::String
    dat::Dict{Any, Any}

    function GitWorker(sys_root, remote_url)
        sys_root = string(sys_root)
        remote_url = string(remote_url)
        depotdir = _depot_dir(sys_root)
        worker_root = _url_dir(depotdir, remote_url)
        dat = Dict{Symbol, Any}()
        new(sys_root, remote_url, worker_root, dat)
    end
    GitWorker(;sys_root, remote_url) = GitWorker(sys_root, remote_url)
    GitWorker(remote_url) = GitWorker(_GW_SYSTEM_DFLT_ROOT, remote_url)
end

# overwrite base
import Base.show 

function Base.show(io::IO, gw::GitWorker) 
    println(io, "GitWorker(;")
    println(io, "   sys_root = \"", gw.sys_root, "\",")
    println(io, "   remote_url = \"", gw.remote_url, "\"")
    println(io, ")")
end

remote_url(gw::GitWorker) = gw.remote_url
sys_root(gw::GitWorker) = gw.sys_root

const _GIT_LINK_KEY = :_git_link_key
function gitlink(gw::GitWorker)
    get(gw, _GIT_LINK_KEY) do
        GitLinks.GitLink(gitlink_dir(gw), remote_url(gw))
    end
end

import Base.lock
lock(f::Function, gw::GitWorker; kwargs...) = lock(f, gitlink(gw); kwargs...)
