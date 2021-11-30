struct GWTask
    task_dir::String

    # Sys dat
    dat::Dict{Any, Any}

    GWTask(task_dir) = new(task_dir)
    GWTask(;task_dir) = GWTask(task_dir)

end

# overwrite base
import Base.show 

function Base.show(io::IO, gwt::GWTask) 
    println(io, "GWTask(;")
    println(io, "   task_dir = \"", gwt.task_dir, "\"")
    println(io, ")")
end

import Base.get!
get!(f::Function, gwt::GWTask, key) = get!(f, gwt.dat, key)
get!(gwt::GWTask, key, val) = get!(gwt.dat, key, val)

import Base.get
get(f::Function, gwt::GWTask, key) = get(f, gwt.dat, key)
get(gwt::GWTask, key, val) = get(gwt.dat, key, val)

set!(gwt::GWTask, key, val) = (gwt.dat[key] = val)
set!(f::Function, gwt::GWTask, key) = (gwt.dat[key] = f())

task_dir(gwt::GWTask) = gwt.task_dir

const _GIT_WORKER_KEY = :_gitworker
function gitworker(gwt::GWTask) 
    get(gwt, _GIT_WORKER_KEY) do
        gwfile = GitWorkers._find_worker_file(task_dir(gwt))
        gw = _gw_from_toml(gwfile)
        isnothing(gw) && error("GitWorker not found!")
        return gw
    end
end

remote_url(gwt::GWTask) = remote_url(gitworker(gwt))
sys_root(gwt::GWTask) = sys_root(gitworker(gwt))

import Base.lock
lock(f::Function, gwt::GWTask; kwargs...) = lock(f, gitworker(gw); kwargs...)
