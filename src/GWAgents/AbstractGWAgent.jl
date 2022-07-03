abstract type AbstractGWAgent end

## ---------------------------------------------------
# AGENT INTERFACE

# sys_root
sys_root(w::AbstractGWAgent) = error("sys_root(w::$(typeof(w))) not implemented!")

# depot dir
gitworkers_dir(w::AbstractGWAgent) = error("gitworkers_dir(w::$(typeof(w))) not implemented!")

# agent_dir
agent_dir(w::AbstractGWAgent) = error("agent_dir(w::$(typeof(w))) not implemented!")

# procs dir
procs_dir(w::AbstractGWAgent) = error("procs_dir(w::$(typeof(w))) not implemented!")

# logs dir
logs_dir(w::AbstractGWAgent) = error("logs_dir(w::$(typeof(w))) not implemented!")

# parent
parent_agent(w::AbstractGWAgent) = error("parent(w::$(typeof(w))) not implemented!")

# agent_ider
agent_ider!(w::AbstractGWAgent, tag::String) = set!(w, :agent_ider, tag)

agent_ider(w::AbstractGWAgent) = get(w, :agent_ider) do
    string(nameof(typeof(w)), "-", UInt64(hash(agent_dir(w))))
    # error("id not defined!")
end

# toml_file
toml_file_name(T::Type{<:AbstractGWAgent}) = string(string(nameof(T)), ".toml")
toml_file_name(w::AbstractGWAgent) = toml_file_name(typeof(w))

toml_file(w::AbstractGWAgent) = get!(w, :toml_file) do
    joinpath(agent_dir(w), toml_file_name(w))
end

write_toml_file(w::AbstractGWAgent) = error("write_toml_file(w::$(typeof(w))) not implemented!")
read_toml_file(T::Type{<:AbstractGWAgent}, ::AbstractString)::AbstractGWAgent = 
    error("read_toml_file(T::$T, fn::AbstractString) not implemented!")

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

# function findup_agent(sT::Type{oT}, w::AbstractGWAgent) where {oT<:AbstractGWAgent}
#     cache = get!(w, :findup_agent_cache) do
#         Dict{String, oT}()
#     end
#     path0 = agent_path()
# end

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
with_logger(f::Function, w::AbstractGWAgent) = with_logger(f, get_logger(w))

