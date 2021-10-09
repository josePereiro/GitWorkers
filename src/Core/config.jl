## ---------------------------------------------------------------
_default_config() = Dict{String, Any}( 
    "julia" => Dict(
        "exe" => "julia",
        "startup_file" => "no",
        "flags" => String[],
    ),
)

## ---------------------------------------------------------------
_gw_configfile() = joinpath(_urldir(), ".gitworker.config.toml")

## ---------------------------------------------------------------
function _save_config(config_dict::Dict; verb=false)
    config_file = _gw_configfile()
    open(config_file, "w") do io
        TOML.print(io, config_dict; sorted=true)
    end
    return config_dict
end

function _save_config!(kstr::AbstractString, val)
    config_dict = _load_config()
    ks = split(kstr, ".")
    ki0 = firstindex(ks)
    ki1 = lastindex(ks) - 1
    config = config_dict
    for ki in ki0:ki1
        config[ks[ki]] = Dict{String, Any}()
        config = config[ks[ki]]
    end
    config[last(ks)] = val
    
    _save_config(config_dict)
end

## ---------------------------------------------------------------
function _load_config()
    config_file = _gw_configfile()
    !isfile(config_file) ? Dict{String, Any}() : TOML.parsefile(config_file)
end

function _load_config(kstr::AbstractString)
    config = _load_config()
    ks = split(kstr, ".")
    for k in ks
        config = config[k]
    end
    return config
end

function _load_config!(kstr::AbstractString, dft)
    config_dict = _load_config()
    ks = split(kstr, ".")
    ki0 = firstindex(ks)
    ki1 = lastindex(ks) - 1
    config = config_dict
    for ki in ki0:ki1
        config = get!(config, ks[ki], Dict{String, Any}())
    end
    config = get!(config, last(ks), dft)
    _save_config(config_dict)
    return config
end

## ---------------------------------------------------------------
_config_haskey(config::Dict, k) = haskey(config, k)
_config_haskey(config, k) = false

_has_config() = isfile(_gw_configfile())

function _has_config(kstr::AbstractString)
    !_has_config() && return false
    
    config_dict = _load_config()
    ks = split(kstr, ".")
    config = config_dict
    for k in ks
        !_config_haskey(config, k) && return false
        config = config[k]
    end
    return true
end