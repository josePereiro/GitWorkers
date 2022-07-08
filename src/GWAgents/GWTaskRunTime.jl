## ---------------------------------------------------
# AGENT INTERFACE

# sys_root
sys_root(::Type{GWTaskRunTime}, agent_dir::AbstractString) = _dirname(agent_dir, 4)

# procs dir
worker_dir(::Type{GWTaskRunTime}, agent_dir::AbstractString) = _dirname(agent_dir, 2)

# procs_dir
procs_dir(::Type{GWTaskRunTime}, agent_dir::AbstractString) = procs_dir(GitWorker, worker_dir(GWTaskRunTime, agent_dir))

# logs_dir
logs_dir(::Type{GWTaskRunTime}, agent_dir::AbstractString) = logs_dir(GitWorker, worker_dir(GWTaskRunTime, agent_dir))

# parent
parent_agent(trt::GWTaskRunTime) = get!(trt, :parent_agent) do
    findup_agent(GitWorker, agent_dir(trt))
end

# agent_ider
agent_ider(trt::GWTaskRunTime) = get!(trt, :agent_ider) do
    basename(agent_dir(trt))
end

# toml_file
write_toml_file(trt::GWTaskRunTime) = get!(trt, :write_toml_file) do
    _write_toml(toml_file(trt))
end 

function read_toml_file(T::Type{GWTaskRunTime}, path::AbstractString)
    tf = isdir(path) ? toml_file(T, path) : path
    isfile(tf) || return nothing
    basename(tf) == toml_file_name(T) || return nothing
    task_dir = dirname(tf)
    return GWTaskRunTime(task_dir; write = false)    
end


## ---------------------------------------------------
# TASK RUN TIME INTERFACE

task_dir(trt::GWTaskRunTime) = agent_dir(trt)

deamon_dir(trt::GWTaskRunTime) = deamon_dir(parent_agent(trt))

parent_deamon(trt::GWTaskRunTime) = parent_deamon(parent_agent(trt))

parent_worker(trt::GWTaskRunTime) = parent_agent(trt)

out_file(trt::GWTaskRunTime) = get!(trt, :out_file) do
    joinpath(agent_dir(trt), "out.log")
end

dat_file(trt::GWTaskRunTime) = get!(trt, :dat_file) do
    joinpath(agent_dir(trt), "dat.jls")
end

readme_file(trt::GWTaskRunTime) = get!(trt, :readme_file) do
    joinpath(agent_dir(trt), "README.md")
end

runme_file(trt::GWTaskRunTime) = get!(trt, :runme_file) do
    joinpath(agent_dir(trt), "runme_task.jl")
end

# STATUS
const NEW_STATUS = "NEW"
const SPAWNED_STATUS = "SPANWED"
const RUNNING_STATUS = "RUNNING"
const ERROR_STATUS = "ERROR"
const DONE_STATUS = "DONE"
const UNKNOWN_STATUS = "UNKNOWN"

status_file(trt::GWTaskRunTime) = get!(trt, :status_file) do
    joinpath(agent_dir(trt), "status.txt")
end

write_status(trt::GWTaskRunTime, status) = _write(status_file(trt), string(status))
read_status(trt::GWTaskRunTime) = _read(status_file(trt), String, UNKNOWN_STATUS)

has_status(trt::GWTaskRunTime, status) = read_status(trt) == status

## ---------------------------------------------------
# REPO

import GitLinks.repo_dir
gitlink(trt::GWTaskRunTime) = get!(trt, :gitlink) do
    gitlink(parent_worker(trt))
end
repo_dir(trt::GWTaskRunTime) = get!(trt, :repo_dir) do
    repo_dir(gitlink(trt))
end
repo_path(trt::GWTaskRunTime, path::AbstractString = agent_dir(trt)) =  
    repo_path(sys_root(trt), repo_dir(trt), path)

repo_agent(trt::GWTaskRunTime; write = false) = get!(trt, :repo_agent) do
    GWTaskRunTime(repo_path(trt); write)
end

## ---------------------------------------------------
# SYNCHRONIZATION

# TASK LAYOUT

# out.log (from server)
# status.txt (from server)
# README.md (from server)

# GWTaskRunTime.toml (from global)
# dat.jls (from global)
# task_runme.jl (from global)

function sync_to_repo(trt::GWTaskRunTime, repo_dir::AbstractString)
    # GWTaskRunTime
    for lpath in [
            out_file(trt),
            status_file(trt),
            readme_file(trt),
            runme_file(trt),
        ]
        rpath = repo_path(trt, repo_dir, lpath)
        _cp(lpath, rpath)
    end
end
sync_to_repo(trt::GWTaskRunTime) = sync_to_repo(trt, repo_dir(trt))

function sync_from_repo(trt::GWTaskRunTime, repo_dir::AbstractString)
    # GWTaskRunTime
    for lpath in [
            toml_file(trt),
            dat_file(trt),
        ]
        rpath = repo_path(trt, repo_dir, lpath)
        _cp(rpath, lpath)
    end
end
sync_from_repo(trt::GWTaskRunTime) = sync_from_repo(trt, repo_dir(trt))

## ---------------------------------------------------
# LOGGING

function collect_listeners!(trt::GWTaskRunTime; from_beginning = false) 
    
    lls = log_listeners(trt)

    # worker logs
    trt_out = out_file(trt)
    get!(lls, trt_out) do
        FileListener(trt_out; from_beginning)
    end
    
    # TODO: listen task logs
    
    return lls

end