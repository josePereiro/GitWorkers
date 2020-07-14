function set_control(control::Dict, val, keys...; DictT = Dict{String, Any})
    dict_ = control
    last_key = keys[end]
    for key in keys
        key == last_key && break
        if !(dict_ isa Dict)
            dict_ = DictT()
        end
        if !haskey(dict_, key) || !(dict_[key] isa Dict)
            dict_[key] = DictT()
        end
        dict_ = dict_[key]
    end
    return dict_[last_key] = val
end

set_config(val, key, keys...) = set_control(ORIGIN_CONFIG, val, key, keys...)
set_status(val, key, keys...) = set_control(LOCAL_STATUS, val, key, keys...)
