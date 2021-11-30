struct GitWorker
    # Git stuff
    sys_root::String
    remote_url::String

    # System data
    dat::Dict{Any, Any}

    GitWorker(sys_root, remote_url) = new(string(sys_root), string(remote_url), Dict{Symbol, Any}())
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

import Base.get!
get!(f::Function, gw::GitWorker, key) = get!(f, gw.dat, key)
get!(gw::GitWorker, key, val) = get!(gw.dat, key, val)

import Base.get
get(f::Function, gw::GitWorker, key) = get(f, gw.dat, key)
get(gw::GitWorker, key, val) = get(gw.dat, key, val)

set!(gw::GitWorker, key, val) = (gw.dat[key] = val)
set!(f::Function, gw::GitWorker, key) = (gw.dat[key] = f())

remote_url(gw::GitWorker) = gw.remote_url
sys_root(gw::GitWorker) = gw.sys_root