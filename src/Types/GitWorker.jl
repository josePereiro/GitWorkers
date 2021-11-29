struct GitWorker
    # Git stuff
    sys_root::String
    remote_url::String

    # System data
    dat::Dict{Symbol, Any}

    GitWorker(sys_root, remote_url) = new(string(sys_root), string(remote_url), Dict{Symbol, Any}())
    GitWorker(;sys_root, remote_url) = GitWorker(sys_root, remote_url)
    GitWorker(remote_url) = GitWorker(_GW_SYSTEM_DFLT_ROOT, remote_url)
end

# overwrite base
import Base.show 

function Base.show(io::IO, gl::GitWorker) 
    println(io, "GitWorker(;")
    println(io, "   sys_root = \"", gl.sys_root, "\",")
    println(io, "   remote_url = \"", gl.remote_url, "\"")
    println(io, ")")
end

import Base.get!
get!(f::Function, gl::GitWorker, key) = get!(f, gl.dat, key)
get!(gl::GitWorker, key, val) = get!(gl.dat, key, val)

import Base.get
get(f::Function, gl::GitWorker, key) = get(f, gl.dat, key)
get(gl::GitWorker, key, val) = get(gl.dat, key, val)

set!(gl::GitWorker, key, val) = (gl.dat[key] = val)
set!(f::Function, gl::GitWorker, key) = (gl.dat[key] = f())

remote_url(gl::GitWorker) = gl.remote_url
sys_root(gl::GitWorker) = gl.sys_root