# TODO: Add tests
"""
    Returns true if the task have a configuration prepared 
    for execution.
    If 'say_why' = true returns a tuple (Bool, String)
    with the result and a description of the rule that 
    returns
"""
function has_executable_config(taskfile; say_why = false)
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")

    # ------------------- CHECK IF COPY -------------------
    # Only tasks in a copy dir must be executed
    !is_copytaskroot(taskfile |> get_taskroot) && 
        return say_why ? (false, "Not a copy Task") : false

    # ------------------- EXEC-CONFIG -------------------
    exec_config = read_task_exec_config_toml(taskfile)
    # task with missing exec_config are no executable
    isnothing(exec_config) && 
        return say_why ? (false, "Missing $TASK_EXEC_CONFIG_FILE_NAME") : false 

    # ------------------- EXEC_ORDER -------------------
    @show exe_order = get_control_val(exec_config, EXE_ORDER_KEY)
    # tasks without valid execution order are no executable
    isnothing(exe_order) && 
        return say_why ? (false, "Invalid or missing $EXE_ORDER_KEY") : false 

    # ------------------- EXEC-STATUS -------------------
    exec_status = read_task_exec_status_toml(taskfile)
    # Tasks without exec_status file are executable
    isnothing(exec_status) && 
        return say_why ? (true, "Missing $TASK_EXEC_STATUS_FILE_NAME") : true 

    # ------------------- LAST_EXEC_ORDER -------------------
    @show last_exe_order = get_control_val(exec_status, LAST_EXE_ORDER_KEY)
    # tasks without valid last execution order are executable
    isnothing(last_exe_order) && 
        return say_why ? (true, "Invalid or missing $LAST_EXE_ORDER_KEY") : true 

    # ------------------- COMPARE-ORDERS -------------------
    # A task with a newer execution order will be executable
    (exe_order > last_exe_order) && 
        return say_why ? (true, "$LAST_EXE_ORDER_KEY < $EXE_ORDER_KEY") : true 

    # by default task are not executable, just in case something 
    # wire happend
    return say_why ? (false, "Default") : false
end