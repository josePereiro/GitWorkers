## ---------------------------------------------------
# AGENT INTERFACE

# deamon_dir
deamon_dir(sys_root) = gitworkers_dir(sys_root)
deamon_dir(w::AbstractGWAgent) = deamon_dir(sys_root(w))

# sys_root
sys_root(::Type{<:GWDeamon}, agent_dir::AbstractString) = _dirname(agent_dir, 1)

# procs dir
procs_dir(::Type{<:GWDeamon}, agent_dir::AbstractString) = joinpath(agent_dir, "deamon-procs")

# logs dir
logs_dir(::Type{<:GWDeamon}, agent_dir::AbstractString) = joinpath(agent_dir, "deamon-logs")

# parent
parent_agent(dm::GWDeamon) = dm

# toml_file
write_toml_file(dm::GWDeamon) = _write_toml(toml_file(dm))

function read_toml_file(T::Type{GWDeamon}, tf::AbstractString)
    isfile(tf) || return nothing
    basename(tf) == toml_file_name(T) || return nothing
    sys_root = sys_root(GWDeamon, dirname(tf))
    return GWDeamon(sys_root; write = false)    
end

## ---------------------------------------------------
# DEAMON INTERFACE

deamon_dir(dm::GWDeamon) = agent_dir(dm)

git_workers(dm::GWDeamon) = get!(dm, :git_workers) do
    Dict{String, GitWorker}()
end

function collect_workers!(dm::GWDeamon)
    workers = git_workers(dm)

    toml_name = toml_file_name(GitWorker)
    for path in _readdir(gitworkers_dir(dm); join = true)
        isdir(path) || continue
        gw_toml_file = joinpath(path, toml_name)
        isfile(gw_toml_file) || continue
        get!(workers, gw_toml_file) do
            read_toml_file(GitWorker, gw_toml_file)
        end
    end

    return workers

end

function collect_listeners!(dm::GWDeamon; from_beginning = false) 
    
    lls = log_listeners(dm)

    # deamon log dir
    ldir = logs_dir(dm)
    get!(lls, ldir) do
        DirListener(ldir; from_beginning)
    end

    # worker logs
    for (_, gw) in collect_workers!(dm)
        
        gw_ldir = logs_dir(gw)
        get!(lls, gw_ldir) do
            DirListener(gw_ldir; from_beginning)
        end

        # tasks out
        for (_, trt) in collect_tasks!(gw)
            trt_out = out_file(trt)
            get!(lls, trt_out) do
                FileListener(trt_out; from_beginning)
            end
        end

    end

    return lls

end

## ---------------------------------------------------
# REPO

repo_path(dm::GWDeamon, gw::GitWorker, path::AbstractString = agent_dir(gw)) = 
    repo_path(sys_root(dm), repo_dir(gw), path)

repo_agent(dm::GWDeamon, gw::GitWorker; write = false) = get!(dm, :repo_agent) do
    GWDeamon(repo_path(dm, gw, sys_root(dm)); write)
end

## ---------------------------------------------------
# SYNCHRONIZATION

function sync_to_repo(dm::GWDeamon, repo_dir::AbstractString)
    for lpath in [
            toml_file(dm),
            logs_dir(dm),
            procs_dir(dm)
        ]
        rpath = repo_path(dm, repo_dir, lpath)
        _cp(lpath, rpath)
    end
end
function sync_to_repo(dm::GWDeamon, gw::GitWorker) 
    sync_to_repo(dm, repo_dir(gw))
    sync_to_repo(gw, repo_dir(gw))
end

# The deamon is created by the server and no update from global (by now)
# is required
sync_from_repo(::GWDeamon, ::AbstractString) = nothing

## ---------------------------------------------------
# PROCS

function del_invalid_proc_registries(dm::GWDeamon)
    # deamon
    _del_invalid_proc_regs(dm)

    # workers
    for (_, gw) in git_workers(dm)
        _del_invalid_proc_regs(gw)
    end

end