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

# ORIGIN_CONFIG
function set_exec_order(taskname, order::Int; info = "", update_date = now()) 
    set_control(ORIGIN_CONFIG, order, taskname, EXE_ORDER_KEY, VALUE_KEY)
    set_control(ORIGIN_CONFIG, info, taskname, EXE_ORDER_KEY, INFO_KEY)
    set_control(ORIGIN_CONFIG, update_date, taskname, EXE_ORDER_KEY, UPDATE_DATE_KEY)
end

function set_kill_sign(taskname, sign::AbstractString; info = "", update_date = now()) 
    set_control(ORIGIN_CONFIG, sign, taskname, KILL_SIGN_KEY, VALUE_KEY)
    set_control(ORIGIN_CONFIG, info, taskname, KILL_SIGN_KEY, INFO_KEY)
    set_control(ORIGIN_CONFIG, update_date, taskname, KILL_SIGN_KEY, UPDATE_DATE_KEY)
end

# LOCAL_STATUS
function set_exec_status(taskname, status::Bool;
        last_order::Int = 0, info = "", update_date = now()) 
    set_control(LOCAL_STATUS, status, taskname, EXECUTION_STATE_KEY, VALUE_KEY)
    set_control(LOCAL_STATUS, last_order, taskname, EXECUTION_STATE_KEY, LAST_EXE_ORDER_KEY)
    set_control(LOCAL_STATUS, info, taskname, EXECUTION_STATE_KEY, INFO_KEY)
    set_control(LOCAL_STATUS, update_date, taskname, EXECUTION_STATE_KEY, UPDATE_DATE_KEY)
end
