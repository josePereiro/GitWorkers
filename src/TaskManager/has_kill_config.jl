"""
    Returns true if the task have a kill configuration.
    If 'say_why' = true returns a tuple (Bool, String)
    with the result and a description of the rule that 
    returns
"""
function has_kill_config(taskfile; say_why = false)
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")

    # ------------------- CHECK IF COPY -------------------
    # Only tasks in a copy dir must be executed
    !is_copytaskroot(taskfile |> get_taskroot) && 
        return say_why ? (false, "Not a copy Task") : false

    # ------------------- EXEC-CONFIG -------------------
    exec_config_file = find_task_exec_config_file(taskfile)
    # tasks without TASK_EXEC_CONFIG_FILE_NAME are no killable
    isnothing(exec_config_file) &&
        return say_why ? (false, "Missing $TASK_EXEC_CONFIG_FILE_NAME") : false 
    
    # ------------------- KILL_SIGN -------------------
    kill_sign = read_control(exec_config_file, KILL_SIGN_KEY)
    # tasks with valid KILL_SIGN_KEY are killiable
    !isnothing(kill_sign) && kill_sign == KILL_SIGN &&
        return say_why ? (true, "Vallid KILL_SIGN $KILL_SIGN_KEY") : true 

    # by default task are not killable, just in case something 
    # wire happend
    return say_why ? (false, "Default") : false
end