
function update_execution_status(taskname)
    
    # update time
    set_status(now(), taskname, EXEC_STATUS_KEY, UPDATE_DATE_KEY)

    # ------------------- CHECK ORIGIN -------------------
    # no data, nothing to do
    if isnothing(get_config(taskname))
        set_status("Task origin config missing", taskname, EXEC_STATUS_KEY, INFO_KEY)
        return set_status(false, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    end

    # ------------------- CHECK EXEC ORDER -------------------
    # no data, nothing to do
    exec_order = get_config(taskname, EXEC_ORDER_KEY, VALUE_KEY)
    if isnothing(exec_order)
        info = "Task origin $(EXEC_ORDER_KEY) missing value"
        set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
        return set_status(false, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    end

    if !(exec_order isa Number) 
        info = "$(EXEC_ORDER_KEY) is not a 'Number', it is a '$(typeof(exec_order))'"
        set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
        return set_status(false, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    end

    # ------------------- CHECK LAST EXEC ORDER -------------------
    last_exec_order = get_status(taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)
    if isnothing(last_exec_order)
        info = "Task $(LAST_EXEC_ORDER_KEY) missing"
        set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
        set_status(exec_order, taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)
        return set_status(true, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    end

    if !(last_exec_order isa Number)
        info = "$(LAST_EXEC_ORDER_KEY) is not a 'Number', it is a '$(typeof(last_exec_order))'"
        set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
        set_status(exec_order, taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)
        return set_status(true, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    end

    if exec_order > last_exec_order
        info = "$(EXEC_ORDER_KEY) > $(LAST_EXEC_ORDER_KEY), run Forrest run!!!"
        set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
        set_status(exec_order, taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)
        return set_status(true, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    else
        info = "$(EXEC_ORDER_KEY) <= $(LAST_EXEC_ORDER_KEY)"
        set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
        set_status(exec_order, taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)
        return set_status(false, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    end

end
