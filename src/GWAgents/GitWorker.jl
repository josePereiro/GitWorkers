
struct GitWorker <: AbstractGWAgent
    dat::Dict

    function GitWorker(
            remote_url::AbstractString, 
            sys_root::AbstractString; 
            write = true
        )
        gw = new(Dict{Any, Any}())
        set!(gw, :remote_url, remote_url)
        set!(gw, :sys_root, sys_root)
        write && write_toml_file(gw)
        return gw
    end

end

## ---------------------------------------------------
# AGENT INTERFACE

# sys_root
sys_root(gw::GitWorker) = get(gw, :sys_root)

# depot dir
gitworkers_dir(gw::GitWorker) = gitworkers_dir(parent_agent(gw))

# agent_dir
_format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
_url_dir(depodir::String, url::String) = joinpath(depodir, _format_url(url))
agent_dir(gw::GitWorker) = get(gw, :agent_dir) do
    _url_dir(gitworkers_dir(gw), remote_url(gw))
end

# procs dir
procs_dir(gw::GitWorker) = get!(gw, :procs_dir) do
    joinpath(agent_dir(gw), "procs")
end

# logs dir
logs_dir(gw::GitWorker) = get!(gw, :logs_dir) do
    joinpath(agent_dir(gw), "logs")
end

# parent
parent_agent(gw::GitWorker) = get!(gw, :parent_agent) do
    GWDeamon(sys_root(gw); write = false)
end

# toml_file
write_toml_file(gw::GitWorker) = _write_toml(toml_file(gw); 
    sys_root = sys_root(gw), 
    remote_url = remote_url(gw)
)

function read_toml_file(::Type{GitWorker}, tf::AbstractString)
    toml = _read_toml(tf)
    isempty(toml) && return nothing
    sys_root = get(toml, "sys_root", nothing)
    remote_url = get(toml, "remote_url", nothing)
    isnothing(sys_root) && return nothing
    isnothing(remote_url) && return nothing
    return GitWorker(remote_url, sys_root; write = false)    
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

tasks_dir(gw::GitWorker) = get!(gw, :tasks_dir) do
    joinpath(agent_dir(gw), "tasks")
end

worker_tasks(gw::GitWorker) = get!(gw, :worker_tasks) do
    Dict{String, GWTaskRunTime}()
end

function collect_tasks!(gw::GitWorker)
    tasks = worker_tasks(gw)

    toml_name = toml_file_name(GWTaskRunTime)
    for path in _readdir(tasks_dir(gw); join = true)
        isdir(path) || continue
        gw_toml_file = joinpath(path, toml_name)
        isfile(gw_toml_file) || continue
        get!(tasks, gw_toml_file) do
            read_toml_file(GWTaskRunTime, gw_toml_file)
        end
    end

    return tasks
end
