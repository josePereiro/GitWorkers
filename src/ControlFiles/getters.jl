function get_control(control::Dict, keys...)
    isempty(keys) && return control
    
    dict_ = control
    last_key = keys[end]
    for key in keys
        key == last_key && break
        if !haskey(dict_, key)
            return nothing
        end
        !(dict_[key] isa Dict) && return nothing
        dict_ = dict_[key]
    end
    return get(dict_, last_key, nothing) 
end

get_config(keys...) = get_control(ORIGIN_CONFIG, keys...)
get_status(keys...) = get_control(LOCAL_STATUS, keys...)
