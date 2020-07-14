"""
    Use he current data available in ORIGIN_CONFIG to 
    update the kill status of a given task in
    LOCAL_STATUS.
"""
function update_kill_status(taskname)
    
    # update time
    set_status(now(), taskname, KILL_STATUS_KEY, UPDATE_DATE_KEY)

    # ------------------- CHECK ORIGIN -------------------
    # no data, nothing to do
    if ismissing(get_config(taskname, KILL_SIGN_KEY))
        info = "Origin task config missing"
        set_status(info, taskname, KILL_STATUS_KEY, INFO_KEY)
        return set_status(false, taskname, KILL_STATUS_KEY, VALUE_KEY)
    end
    origin_control = ORIGIN_CONFIG[taskname]

    # ------------------- CHECK KILL SIGN -------------------
    # no data, nothing to do
    kill_sign = get_config(taskname, KILL_SIGN_KEY, VALUE_KEY)
    if ismissing(kill_sign)
        info = "Task origin $(KILL_SIGN_KEY) missing value"
        set_status(info, taskname, KILL_STATUS_KEY, INFO_KEY)
        return set_status(false, taskname, KILL_STATUS_KEY, VALUE_KEY)
    end

    if kill_sign == KILL_SIGN
        info = "$(KILL_SIGN_KEY) == $(KILL_SIGN). Die die die my darling!!!"
        set_status(info, taskname, KILL_STATUS_KEY, INFO_KEY)
        return set_status(true, taskname, KILL_STATUS_KEY, VALUE_KEY)
    else
        info = "$(KILL_SIGN_KEY) != $(KILL_SIGN)"
        set_status(info, taskname, KILL_STATUS_KEY, INFO_KEY)
        return set_status(false, taskname, KILL_STATUS_KEY, VALUE_KEY)
    end

end