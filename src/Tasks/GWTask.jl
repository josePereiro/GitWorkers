# contains the information required for running a task
struct GWTask <: AbstractWorker
    # Task
    tid::String

    # AbstractWorker
    worker_root::String
    dat::Dict{Any, Any}

    function GWTask(tid, task_dir) 
        tid = string(tid)
        worker_root = string(task_dir)
        gwt = new(tid, worker_root, Dict{Any, Any}())
        wid!(gwt, tid)
        return gwt
    end
    GWTask(;tid, task_dir) = GWTask(tid, task_dir)

end

# overwrite base
import Base.show 

function Base.show(io::IO, gwt::GWTask) 
    println(io, "GWTask(;")
    println(io, "   task_id = \"", task_id(gwt), "\",")
    println(io, "   task_dir = \"", task_dir(gwt), "\"")
    println(io, ")")
end

task_id(gwt::GWTask) = gwt.tid
task_dir(gwt::GWTask) = worker_root(gwt)

const _GIT_WORKER_KEY = :_gitworker
function gitworker(gwt::GWTask) 
    get(gwt, _GIT_WORKER_KEY) do
        gwfile = _find_worker_file(task_dir(gwt))
        gw = _gw_from_toml(gwfile)
        isnothing(gw) && error("GitWorker not found!")
        return gw
    end
end

remote_url(gwt::GWTask) = remote_url(gitworker(gwt))
sys_root(gwt::GWTask) = sys_root(gitworker(gwt))

import Base.lock
lock(f::Function, gwt::GWTask; kwargs...) = lock(f, gitworker(gw); kwargs...)
