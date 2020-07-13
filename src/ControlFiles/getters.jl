function get_control(control::Dict, keys...)
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

# ORIGIN_CONFIG
get_exec_order(taskname, subkey = VALUE_KEY) = 
    get_control(ORIGIN_CONFIG, taskname, EXEC_ORDER_KEY, subkey)

get_kill_sign(taskname, subkey = VALUE_KEY) = 
    get_control(ORIGIN_CONFIG, taskname, KILL_SIGN_KEY, subkey)

# LOCAL_STATUS
get_exec_status(taskname, subkey = VALUE_KEY) = 
    get_control(LOCAL_STATUS, taskname, EXECUTION_STATUS_KEY, subkey)