function get_control(control::Dict, keys...; default = missing)
    isempty(keys) && return control
    
    dict_ = control
    last_key = keys[end]
    for key in keys
        key == last_key && break
        if !haskey(dict_, key)
            return default
        end
        !(dict_[key] isa Dict) && return default
        dict_ = dict_[key]
    end
    return get(dict_, last_key, default) 
end

get_config(keys...; default = missing) = get_control(ORIGIN_CONFIG, keys...; default = default)
get_status(keys...; default = missing) = get_control(LOCAL_STATUS, keys...; default = default)
