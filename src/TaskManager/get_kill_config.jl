"""
    Returns true if the task have a kill configuration.
    If 'say_why' = true returns a tuple (Bool, String)
    with the result and a description of the rule that 
    returns
"""
function get_kill_config(taskfile)
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")
    taskroot = taskfile |> get_taskroot

    # by default task are not killable, just in case something 
    # wire happend
    killable = false
    why = "Default"
    exec_config_file = build_task_exec_config_file(taskroot)
    kill_sign = read_control(exec_config_file, KILL_SIGN_KEY)

    if !is_copytaskroot(taskroot)
        # ------------------- CHECK IF COPY -------------------
        # Only tasks in a copy dir must be executed
        why = "Not a copy Task"

    elseif !isfile(exec_config_file)
        # ------------------- EXEC-CONFIG -------------------
        # tasks without TASK_EXEC_CONFIG_FILE_NAME are no killable
        why = "Missing $TASK_EXEC_CONFIG_FILE_NAME"

    elseif isnothing(kill_sign)
        # ------------------- INVALID KILL SIGN -------------------
        # tasks with valid KILL_SIGN_KEY are not killable
        why =  "Invalid KILL_SIGN $KILL_SIGN_KEY"

    elseif kill_sign == KILL_SIGN
        # ------------------- KILL_SIGN -------------------
        # tasks with valid KILL_SIGN_KEY are killable
        killable = true
        why =  "Valid KILL_SIGN $KILL_SIGN_KEY"
    end

    write_task_exec_status(taskfile, KILL_ORDER_STATE_KEY, killable)
    write_task_exec_status(taskfile, KILL_ORDER_STATE_INFO_KEY, why)

    return killable    
end