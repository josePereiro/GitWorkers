## ---------------------------------------------------
# AGENT INTERFACE

# agent_dir
agent_dir(w::AbstractGWAgent) = get(w, :agent_dir)

# depot dir
gitworkers_dir(sys_root::AbstractString) = joinpath(sys_root, ".gitworkers")
gitworkers_dir(w::AbstractGWAgent) = gitworkers_dir(sys_root(w))

# sys_root
sys_root(T::Type{<:AbstractGWAgent}, ::AbstractString) = error("sys_root(T::$T, agent_dir::AbstractString) not implemented!")
sys_root(w::AbstractGWAgent) = get!(w, :sys_root) do
    sys_root(typeof(w), agent_dir(w))
end    

# logs_dir
logs_dir(T::Type{<:AbstractGWAgent}, ::AbstractString) = error("logs_dir(T::$T, agent_dir::AbstractString) not implemented!")
logs_dir(w::AbstractGWAgent) = get!(w, :logs_dir) do
    logs_dir(typeof(w), agent_dir(w))
end    

# procs_dir
procs_dir(T::Type{<:AbstractGWAgent}, ::AbstractString) = error("procs_dir(T::$T, agent_dir::AbstractString) not implemented!")
procs_dir(w::AbstractGWAgent) = get!(w, :procs_dir) do
    procs_dir(typeof(w), agent_dir(w))
end    

# parent
parent_agent(w::AbstractGWAgent) = error("parent(w::$(typeof(w))) not implemented!")

# agent_ider
agent_ider(w::AbstractGWAgent) = get!(w, :agent_ider) do
    return string(nameof(typeof(w)))
end

# toml_file
toml_file_name(T::Type{<:AbstractGWAgent}) = string(string(nameof(T)), ".toml")
toml_file_name(w::AbstractGWAgent) = toml_file_name(typeof(w))

toml_file(T::Type{<:AbstractGWAgent}, agent_dir) = joinpath(agent_dir, toml_file_name(T))
toml_file(w::AbstractGWAgent) = get!(w, :toml_file) do
    toml_file(typeof(w), agent_dir(w))
end

write_toml_file(w::AbstractGWAgent) = error("write_toml_file(w::$(typeof(w))) not implemented!")

read_toml_file(T::Type{<:AbstractGWAgent}, ::AbstractString)::Union{Nothing, T} = 
    error("read_toml_file(T::$T, fn::AbstractString) not implemented!")

is_agent_dir(T::Type{GWTaskRunTime}, path) = !isnothing(read_toml_file(T, path))

# TODO: think in a cache (global or local) for the findup methods
function findup_toml_file(T::Type{<:AbstractGWAgent}, path0; 
        root = homedir()
    )
    tfile = toml_file_name(T)
    return findup(path0; root) do path
        basename(path) == tfile
    end
end

function findup_agent(T::Type{<:AbstractGWAgent}, path0; root = homedir())
    tfl = findup_toml_file(T, path0; root)
    isempty(tfl) && return nothing
    return read_toml_file(T, tfl)
end

## ---------------------------------------------------
# REPO

repo_path(sys_root::AbstractString, repo_dir::AbstractString, path::AbstractString = agent_dir(gw)) = 
    replace(path, sys_root => repo_dir)
repo_path(w::AbstractGWAgent, repo_dir::AbstractString, path::AbstractString = agent_dir(gw)) = get!(w, (:repo_path, path)) do
    repo_path(sys_root(w), repo_dir, path)
end


## ---------------------------------------------------
# SYNCHRONIZATION

# TODO: maybe only upload logs on demand

sync_to_repo(w::AbstractGWAgent, ::AbstractString) = 
    error("sync_to_repo(w::$(typeof(w)), repo_dir) not implemented!")


sync_from_repo(w::AbstractGWAgent, ::AbstractString) = 
    error("sync_to_repo(w::$(typeof(w)), repo_dir) not implemented!")

## ---------------------------------------------------
# PROCS

proc_reg_file(w::AbstractGWAgent, pid = getpid()) = _reg_proc_file(w, agent_ider(w), pid)

write_proc_reg(w::AbstractGWAgent, pid = getpid()) = _reg_proc(w, agent_ider(w), pid)

safe_kill(w::AbstractGWAgent) = _safe_kill(w, agent_ider(w))

safe_killall(w::AbstractGWAgent) = _safe_killall(w, agent_ider(w))

duplicated_procs(w::AbstractGWAgent) = _findall_proc_reg(w, agent_ider(w))

clear_proc_regs(w::AbstractGWAgent) = _rm(procs_dir(w))

is_running(w::AbstractGWAgent) = _is_valid_proc(w, agent_ider(w))

## ---------------------------------------------------
# BASE

import Base.relpath
relpath(w::AbstractGWAgent, path::String) = _relbasepath(path, agent_dir(w))

import Base.abspath
abspath(w::AbstractGWAgent, path::String) = joinpath(agent_dir(w), relpath(w, path))

import Base.mkpath
mkpath(w::AbstractGWAgent) = mkpath(agent_dir(w))

import Base.get!
get!(f::Function, w::AbstractGWAgent, key) = get!(f, w.dat, key)
get!(w::AbstractGWAgent, key, val) = get!(w.dat, key, val)

import Base.get
get(f::Function, w::AbstractGWAgent, key) = get(f, w.dat, key)
get(w::AbstractGWAgent, key, val) = get(w.dat, key, val)
get(w::AbstractGWAgent, key) = getindex(w.dat, key)

set!(w::AbstractGWAgent, key, val) = (w.dat[key] = val)
set!(f::Function, w::AbstractGWAgent, key) = (w.dat[key] = f())

## ---------------------------------------------------
# LOGGING

const _GW_LOGGER_KEY = "_logger"
get_logger(w::AbstractGWAgent) = get!(w, _GW_LOGGER_KEY) do
    ldir = logs_dir(w)
    mkpath(ldir)
    # return _tee_logger(ldir, agent_ider(w))
    return _rotating_logger(ldir, agent_ider(w))
end

import Logging.with_logger
with_logger(f::Function, w::AbstractGWAgent) = _with_logger(f, get_logger(w))

log_info(w::AbstractGWAgent, title; kwargs...) = with_logger(w) do
    @info(title, kwargs...)
end

log_warn(w::AbstractGWAgent, title; kwargs...) = with_logger(w) do
    @warn(title, kwargs...)
end

log_error(w::AbstractGWAgent, title; kwargs...) = with_logger(w) do
    @error(title, kwargs...)
end

## ---------------------------------------------------
# LISTENERS

last_printed(w::AbstractGWAgent) = get!(w, :last_printed, "")
last_printed!(w::AbstractGWAgent, file) = set!(w, :last_printed, file)

log_listeners(w::AbstractGWAgent) = get!(w, :log_listeners) do
    Dict{String, Union{FileListener, DirListener}}()
end

function print_listeners(w::AbstractGWAgent)

    for (path, ll) in log_listeners(w)
        ll_bytes = _readbytes!(ll)
        isempty(ll_bytes) && continue
        bytes_dict = (ll_bytes isa Dict) ? ll_bytes : Dict(path => ll_bytes)
        for (file, bytes) in bytes_dict
            
            # print title
            if last_printed(w) != file
                last_printed!(w, file)
                title = string("\n\nFrom ", file, "\n")
                printstyled(title; color = :blue)
            end

            # print
            print(String(bytes))
            
        end
    end
end

function print_listeners!(w::AbstractGWAgent; from_beginning = false) 
    collect_listeners!(w; from_beginning)
    print_listeners(w)
end
