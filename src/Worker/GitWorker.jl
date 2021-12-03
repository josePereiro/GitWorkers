struct GitWorker <: AbstractGWRegistry
    # GW stuff
    sys_root::String
    remote_url::String

    # Register
    home_dir::String
    dat::Dict{Any, Any}

    function GitWorker(sys_root, remote_url)
        sys_root = string(sys_root)
        remote_url = string(remote_url)
        depotdir = gw_deamon_dir(sys_root)
        home_dir = worker_dir(depotdir, remote_url)
        dat = Dict{Symbol, Any}()
        new(sys_root, remote_url, home_dir, dat)
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
