
struct GWTaskRunTime <: AbstractGWAgent
    dat::Dict

    function GWTaskRunTime(
            task_dir::AbstractString; 
            write = true
        )
        trt = new(Dict{Any, Any}())
        set!(trt, :agent_dir, task_dir)
        write && write_toml_file(trt)
        return trt
    end

end

## ---------------------------------------------------
# AGENT INTERFACE

# sys_root
sys_root(trt::GWTaskRunTime) = sys_root(parent_agent(trt))

# depot dir
gitworkers_dir(trt::GWTaskRunTime) = gitworkers_dir(parent_agent(trt))

# agent_dir
agent_dir(trt::GWTaskRunTime) = get(trt, :agent_dir)

# procs dir
procs_dir(trt::GWTaskRunTime) = procs_dir(parent_agent(trt))

# parent
parent_agent(trt::GWTaskRunTime) = get!(trt, :parent_agent) do
    findup_agent(GitWorker, agent_dir(trt))
end

# toml_file
write_toml_file(trt::GWTaskRunTime) = _write_toml(toml_file(trt); 
    task_dir = task_dir(trt)
)

function read_toml_file(::Type{GWTaskRunTime}, tf::AbstractString)
    toml = _read_toml(tf)
    isempty(toml) && return nothing
    task_dir = get(toml, "task_dir", nothing)
    isnothing(task_dir) && return nothing
    return GWTaskRunTime(task_dir; write = false)    
end

## ---------------------------------------------------
# TASK RUN TIME INTERFACE

task_dir(trt::GWTaskRunTime) = agent_dir(trt)

deamon_dir(trt::GWTaskRunTime) = deamon_dir(parent_agent(trt))

parent_deamon(trt::GWTaskRunTime) = parent_deamon(trt)

parent_worker(trt::GWTaskRunTime) = parent_agent(trt)

out_file(trt::GWTaskRunTime) = get!(trt, :out_file) do
    joinpath(agent_dir(trt), "out.log")
end

meta_file(trt::GWTaskRunTime) = get!(trt, :meta_file) do
    joinpath(agent_dir(trt), "out.log")
end

status_file(trt::GWTaskRunTime) = get!(trt, :status_file) do
    joinpath(agent_dir(trt), "status.toml")
end

readme_file(trt::GWTaskRunTime) = get!(trt, :readme_file) do
    joinpath(agent_dir(trt), "README.md")
end


