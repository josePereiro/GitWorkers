
function update_execution_status(taskname)

    # task LOCAL_STATUS
    if !haskey(LOCAL_STATUS, taskname)
        LOCAL_STATUS[taskname] = Dict()
    end

    # running_status
    if !haskey(LOCAL_STATUS[taskname], EXECUTION_STATUS_KEY)
        LOCAL_STATUS[taskname][EXECUTION_STATUS_KEY] = Dict()
    end
    exec_state = LOCAL_STATUS[taskname][EXECUTION_STATUS_KEY]
    
    # ------------------- DEFAULT -------------------
    exec_state[VALUE_KEY] = false
    exec_state[INFO_KEY] = "Default"
    
    # update date
    exec_state[UPDATE_DATE_KEY] = now()

    # ------------------- CHECK ORIGIN -------------------
    # no data, nothing to do
    if !haskey(ORIGIN_CONFIG, taskname) 
        exec_state[INFO_KEY] = "Task origin config missing"
        return exec_state[VALUE_KEY] = false
    end
    origin_control = ORIGIN_CONFIG[taskname]

    # ------------------- CHECK EXEC ORDER -------------------
    # no data, nothing to do
    if !haskey(origin_control, EXEC_ORDER_KEY) || 
        !haskey(origin_control[EXEC_ORDER_KEY], VALUE_KEY)
        exec_state[INFO_KEY] = "Task origin $(EXEC_ORDER_KEY) missing value"
        return exec_state[VALUE_KEY] = false
    end
    exe_order = origin_control[EXEC_ORDER_KEY][VALUE_KEY]

    if !(exe_order isa Number) 
        exec_state[INFO_KEY] = "$(EXEC_ORDER_KEY) is not a Number, " * 
            "it is a $(typeof(exe_order))"
        return exec_state[VALUE_KEY] = false
    end

    # ------------------- CHECK LAST EXEC ORDER -------------------
    if !haskey(exec_state, LAST_EXEC_ORDER_KEY)
        exec_state[INFO_KEY] = "Task $(LAST_EXEC_ORDER_KEY) missing"
        exec_state[LAST_EXEC_ORDER_KEY] = exe_order
        return exec_state[VALUE_KEY] = true
    end

    if !(exec_state[LAST_EXEC_ORDER_KEY] isa Number)
        exec_state[INFO_KEY] = "$(LAST_EXEC_ORDER_KEY) is not a Number, " * 
            "it is a $(typeof(exec_state[LAST_EXEC_ORDER_KEY]))"
        exec_state[LAST_EXEC_ORDER_KEY] = exe_order
        return exec_state[VALUE_KEY] = true
    end

    if exe_order > exec_state[LAST_EXEC_ORDER_KEY]
        exec_state[INFO_KEY] = "$(EXEC_ORDER_KEY) > $(LAST_EXEC_ORDER_KEY), run Forrest run!!!"
        exec_state[LAST_EXEC_ORDER_KEY] = exe_order
        return exec_state[VALUE_KEY] = true
    end
end
