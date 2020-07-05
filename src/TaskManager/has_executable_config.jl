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
    exec_config_file = find_task_exec_config_file(taskfile)
    # tasks without TASK_EXEC_CONFIG_FILE_NAME are no executable
    isnothing(exec_config_file) &&
        return say_why ? (false, "Missing $TASK_EXEC_CONFIG_FILE_NAME") : false 
    
    # ------------------- EXEC_ORDER -------------------
    exe_order = read_control(exec_config_file, EXE_ORDER_KEY)
    # tasks without valid execution order are no executable
    isnothing(exe_order) && 
        return say_why ? (false, "Invalid or missing $EXE_ORDER_KEY") : false 

    # ------------------- EXEC-STATUS -------------------
    exec_status_file = find_task_exec_status_file(taskfile)
    # Tasks without TASK_EXEC_STATUS_FILE_NAME file are not executable
    isnothing(exec_status_file) && 
        return say_why ? (false, "Missing $TASK_EXEC_STATUS_FILE_NAME") : false

    # ------------------- LAST_EXEC_ORDER -------------------
    last_exe_order = read_control(exec_status_file, LAST_EXE_ORDER_KEY)
    # tasks without valid last execution order are not executable
    isnothing(last_exe_order) && 
        return say_why ? (false, "Invalid or missing $LAST_EXE_ORDER_KEY") : false

    # ------------------- COMPARE-ORDERS -------------------
    # A task with a newer execution order will be executable
    (exe_order > last_exe_order) && 
        return say_why ? (true, "$LAST_EXE_ORDER_KEY < $EXE_ORDER_KEY") : true 

    # by default task are not executable, just in case something 
    # wire happend
    return say_why ? (false, "Default") : false
end