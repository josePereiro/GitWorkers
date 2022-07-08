## ---------------------------------------------------
# AGENT INTERFACE

# worker_dir
_format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
_url_dir(depodir::String, url::String) = joinpath(depodir, _format_url(url))
worker_dir(sys_root, remote_url) = _url_dir(gitworkers_dir(sys_root), remote_url)

# sys_root
sys_root(::Type{<:GitWorker}, agent_dir::AbstractString) = _dirname(agent_dir, 2)

# procs dir
procs_dir(::Type{<:GitWorker}, agent_dir::AbstractString) = joinpath(agent_dir, "procs")

# logs dir
logs_dir(::Type{<:GitWorker}, agent_dir::AbstractString) = joinpath(agent_dir, "logs")

# parent
parent_agent(gw::GitWorker) = get!(gw, :parent_agent) do
    GWDeamon(sys_root(gw); write = false)
end

# toml_file
write_toml_file(gw::GitWorker) = _write_toml(toml_file(gw); 
    remote_url = remote_url(gw)
)

function read_toml_file(T::Type{GitWorker}, path::AbstractString)
    tf = isdir(path) ? toml_file(T, path) : path
    isfile(tf) || return nothing
    basename(tf) == toml_file_name(T) || return nothing
    toml = _read_toml(tf)
    isempty(toml) && return nothing
    remote_url = get(toml, "remote_url", nothing)
    isnothing(remote_url) && return nothing
    sys_root_ = sys_root(GitWorker, dirname(tf))
    return GitWorker(remote_url, sys_root_; write = false)    
end

## ---------------------------------------------------
# GIT WORKER INTERFACE

parent_deamon(gw::GitWorker) = parent_agent(gw)

deamon_dir(gw::GitWorker) = deamon_dir(parent_agent(gw))

worker_dir(gw::GitWorker) = agent_dir(gw)

remote_url(gw::GitWorker) = get(gw, :remote_url)

gitlink_dir(gw::GitWorker) = get!(gw, :gitlink_dir) do
    joinpath(agent_dir(gw), "link")
end

gitlink(gw::GitWorker) = get!(gw, :gitlink) do
    GitLink(gitlink_dir(gw), remote_url(gw))
end

runme_file(gw::GitWorker) = joinpath(agent_dir(gw), "runme_worker.jl")

## ---------------------------------------------------
# TASKS

tasks_dir(gw::GitWorker) = get!(gw, :tasks_dir) do
    joinpath(agent_dir(gw), "tasks")
end

worker_tasks(gw::GitWorker) = get!(gw, :worker_tasks) do
    Dict{String, GWTaskRunTime}()
end

collect_tasks!(gw::GitWorker) = 
    _collect_tasks!(worker_tasks(gw), tasks_dir(gw))

function _task_id(tname)
    date = now()
    tstr = Dates.format(date, "yyyy-mm-dd\\THHMMSS")
    string(tstr, "-", tname)
end

function create_task(gw::GitWorker, tname::AbstractString = "TASK"; write = true)
    tdir = joinpath(tasks_dir(gw), _task_id(tname))
    return GWTaskRunTime(tdir; write)
end

## ---------------------------------------------------
# REPO 

import GitLinks.repo_dir
repo_dir(gw::GitWorker) = get!(gw, :repo_dir) do
    repo_dir(gitlink(gw))
end
repo_path(gw::GitWorker, path::AbstractString = agent_dir(gw)) = 
    repo_path(gw, repo_dir(gw), path)

repo_agent(gw::GitWorker; write = false) = get!(gw, :repo_agent) do
    GitWorker(remote_url(gw), repo_path(gw, sys_root(gw)); write)
end

## ---------------------------------------------------
# SYNCHRONIZATION

function sync_to_repo(gw::GitWorker, repo_dir::AbstractString)

    # Worker
    for lpath in [
            toml_file(gw),
            logs_dir(gw),
            procs_dir(gw), 
            runme_file(gw),
        ]
        rpath = repo_path(gw, repo_dir, lpath)
        _cp(lpath, rpath)
    end

    # Tasks
    for (_, trt) in collect_tasks!(gw)
        sync_to_repo(trt, repo_dir)
    end

end
sync_to_repo(gw::GitWorker) = sync_to_repo(gw, repo_dir(gw))

function sync_from_repo(gw::GitWorker, repo_dir::AbstractString)
    
    # worker
    # No global info is required (by now)
    
    # Find New Tasks
    ltsdir = tasks_dir(gw)
    rtsdir = repo_path(gw, ltsdir)
    for rtdir in _readdir(rtsdir; join = true)
        is_agent_dir(GWTaskRunTime, rtdir) || continue
        ltdir = joinpath(ltsdir, basename(rtdir))
        isdir(ltdir) && continue # do not rewrite # TODO: implement repairs?
        _cp(rtdir, ltdir)
    end
    
    # Old Tasks
    for (_, trt) in collect_tasks!(gw)
        sync_from_repo(trt, repo_dir)
    end
end
sync_from_repo(gw::GitWorker) = sync_from_repo(gw, repo_dir(gw))

## ---------------------------------------------------
# PROCS

del_invalid_proc_registries(gw::GitWorker) = _del_invalid_proc_regs(gw)
