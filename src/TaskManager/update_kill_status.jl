"""
    Use he current data available in ORIGIN_CONFIG to 
    update the kill status of a given task in
    LOCAL_STATUS.
"""
function update_kill_status(taskname)

    # task LOCAL_STATUS
    if !haskey(LOCAL_STATUS, taskname)
        LOCAL_STATUS[taskname] = Dict()
    end
    
    # kill state
    if !haskey(LOCAL_STATUS[taskname], KILL_STATUS_KEY)
        LOCAL_STATUS[taskname][KILL_STATUS_KEY] = Dict()
    end
    kill_state = LOCAL_STATUS[taskname][KILL_STATUS_KEY]
    
    # ------------------- DEFAULT -------------------
    kill_state[VALUE_KEY] = false
    kill_state[INFO_KEY] = "Default"

    # Update time
    kill_state[UPDATE_DATE_KEY] = now()

    # ------------------- CHECK ORIGIN -------------------
    # no data, nothing to do
    if !haskey(ORIGIN_CONFIG, taskname) 
        kill_state[INFO_KEY] = "Task origin config missing"
        return kill_state[VALUE_KEY] = false
    end
    origin_control = ORIGIN_CONFIG[taskname]

    # ------------------- CHECK KILL SIGN -------------------
    # no data, nothing to do
    if !haskey(origin_control, KILL_SIGN_KEY) || 
            !haskey(origin_control[KILL_SIGN_KEY], VALUE_KEY)
        kill_state[INFO_KEY] = "Task origin $(KILL_SIGN_KEY) missing value"
        return kill_state[VALUE_KEY] = false
    end

    # check kill sign
    if origin_control[KILL_SIGN_KEY][VALUE_KEY] == KILL_SIGN
        kill_state[INFO_KEY] = "$(KILL_SIGN_KEY) == $(KILL_SIGN). Die die die my darling!!!"
        return kill_state[VALUE_KEY] = true
    else
        kill_state[INFO_KEY] = "$(KILL_SIGN_KEY) != $(KILL_SIGN)"
        return kill_state[VALUE_KEY] = false
    end
end