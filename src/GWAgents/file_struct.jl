# # COMMON


# # DEAMON
# gitworkers_dir(sys_root::AbstractString) = joinpath(sys_root, ".gitworkers")

# # WORKER
# _format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
# _url_dir(depodir::String, url::String) = joinpath(depodir, _format_url(url))

# _worker_dir(sys_root, remote_url) = _url_dir(gitworkers_dir(sys_root), remote_url)

# _sys_root(::Type{GitWorker}, agent_dir) = dirname(agent_dir)
# _procs_dir(::Type{GitWorker}, agent_dir) = joinpath(agent_dir, "procs")
# _logs_dir(::Type{GitWorker}, agent_dir) = joinpath(agent_dir, "logs")

# # TASK RUNTIME