
struct GWDeamon <: AbstractGWAgent
    dat::Dict

    function GWDeamon(sys_root::AbstractString; write = true)
        dm = new(Dict{Any, Any}())
        set!(dm, :sys_root, sys_root)
        write && write_toml_file(dm)
        return dm
    end

end

## ---------------------------------------------------
# AGENT INTERFACE

# sys_root
sys_root(dm::GWDeamon) = get(dm, :sys_root)

# depot dir
gitworkers_dir(dm::GWDeamon) = get!(dm, :gitworkers_dir) do
    joinpath(sys_root(dm), ".gitworkers")
end

# agent_dir
agent_dir(dm::GWDeamon) = get!(dm, :agent_dir) do
    joinpath(gitworkers_dir(dm), "gw-deamon")
end

# procs dir
procs_dir(dm::GWDeamon) = get!(dm, :procs_dir) do
    joinpath(agent_dir(dm), "procs")
end

# logs dir
logs_dir(dm::GWDeamon) = get!(dm, :logs_dir) do
    joinpath(agent_dir(dm), "logs")
end

# parent
parent_agent(dm::GWDeamon) = dm

# toml_file
write_toml_file(dm::GWDeamon) = _write_toml(toml_file(dm); 
    sys_root = sys_root(dm)
)

function read_toml_file(::Type{GWDeamon}, tf::AbstractString)
    toml = _read_toml(tf)
    isempty(toml) && return nothing
    sys_root = get(toml, "sys_root", nothing)
    isnothing(sys_root) && return nothing
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

log_listeners(dm::GWDeamon) = get!(dm, :log_listeners) do
    Dict{String, Union{FileListener, DirListener}}()
end

function collect_listeners!(dm::GWDeamon; from_beginning = false) 
    
    lls = log_listeners(dm)

    # deamon log dir
    ldir = logs_dir(dm)
    get!(lls, ldir) do
        DirListener(ldir; from_beginning)
    end

    # worker logs
    collect_workers!(dm)
    for (_, gw) in git_workers(dm)
        
        gw_ldir = logs_dir(gw)
        get!(lls, gw_ldir) do
            DirListener(gw_ldir; from_beginning)
        end

        # tasks
        for (_, trt) in collect_tasks!(gw)
            trt_out = out_file(trt)
            get!(lls, trt_out) do
                FileListener(trt_out; from_beginning)
            end
        end

    end

    return lls

end

function _print_new_bytes(title, bytes::Vector)
    
    str = String(bytes)

    # print
    printstyled(title; color = :blue)
    println()
    println(str)
    println()

end

function print_listeners(dm::GWDeamon)

    lls = log_listeners(dm)
    depot_dir = gitworkers_dir(dm)

    for (path, ll) in lls
        if isdir(path)
            dir_bytes = _readbytes!(ll)
            for (file, bytes) in dir_bytes
                title = string("From ", _relbasepath(file, depot_dir))
                _print_new_bytes(title, bytes)
            end
        elseif isfile(path)
            bytes = _readbytes!(ll)
            title = string("From ", _relbasepath(path, depot_dir))
            _print_new_bytes(title, bytes)
        end
    end

end

print_listeners!(dm::GWDeamon) = (collect_listeners!(dm); print_listeners(dm))