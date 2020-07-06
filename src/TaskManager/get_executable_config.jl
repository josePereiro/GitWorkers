"""
    Returns the oxe_order if the task have a configuration prepared 
    for execution. false is the default not executable flag
    If 'say_why' = true returns a tuple (Int, String)
    with the result and a description of the rule that 
    returns
"""
function get_executable_config(taskfile)

    # checks
    !is_task(taskfile) && error("Not a valid taskfile")
    taskroot = taskfile |> get_taskroot

    # by default task are not executable, just in case something 
    # wire happend
    executable = false
    why = "Default"

    exec_config_file = build_task_exec_config_file(taskroot)
    exe_order = read_control(exec_config_file, EXE_ORDER_KEY)
    exec_status_file = build_task_exec_status_file(taskroot)
    last_exe_order = read_control(exec_status_file, LAST_EXE_ORDER_KEY)

    if !is_copytaskroot(taskroot)
        # ------------------- CHECK IF COPY -------------------
        # Only tasks in a copy dir must be executed
        why = "Not a copy Task"
    elseif !isfile(exec_config_file)
        # ------------------- EXEC-CONFIG -------------------
        # tasks without TASK_EXEC_CONFIG_FILE_NAME are no executable
        why = "Missing $TASK_EXEC_CONFIG_FILE_NAME"
    
    elseif isnothing(exe_order)
        # ------------------- EXEC_ORDER -------------------
        # tasks without valid execution order are no executable
        why = "Invalid or missing $EXE_ORDER_KEY"
    
    elseif !isfile(exec_status_file) 
        # ------------------- EXEC-STATUS -------------------
        # Tasks without TASK_EXEC_STATUS_FILE_NAME file are not executable
        why = "Missing $TASK_EXEC_STATUS_FILE_NAME"

    elseif isnothing(last_exe_order)
        # ------------------- LAST_EXEC_ORDER -------------------
        # tasks without valid last execution order are executable
        executable = true
        why = "Invalid or missing $LAST_EXE_ORDER_KEY"
        write_task_exec_status(taskfile, LAST_EXE_ORDER_KEY, exe_order)
    elseif (exe_order > last_exe_order)
        # ------------------- COMPARE-ORDERS -------------------
        # A task with a newer execution order will be executable
        executable = true
        why = "$LAST_EXE_ORDER_KEY < $EXE_ORDER_KEY"
        write_task_exec_status(taskfile, LAST_EXE_ORDER_KEY, exe_order)
    end

    write_task_exec_status(taskfile, EXE_ORDER_STATE_KEY, executable)
    write_task_exec_status(taskfile, EXE_ORDER_STATE_INFO_KEY, why)

    
    return executable
end

# function executable