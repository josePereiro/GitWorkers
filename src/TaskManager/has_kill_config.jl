"""
    Returns true if the task have a kill configuration.
    If 'say_why' = true returns a tuple (Bool, String)
    with the result and a description of the rule that 
    returns
"""
function has_kill_config(taskfile)
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")

    # ------------------- CHECK IF COPY -------------------
    # Only tasks in a copy dir must be executed
    !is_copytaskroot(taskfile |> get_taskroot) && 
        return say_why ? (false, "Not a copy Task") : false

    # ------------------- EXEC-CONFIG -------------------
    exec_config = read_task_exec_config_toml(taskfile)
    # tasks with missing exec_config will always be killed
    isnothing(exec_config) && 
        return say_why ? (true, "Missing $TASK_EXEC_CONFIG_FILE_NAME") : true

    # ------------------- KILL_SIGN -------------------
    exe_order = get_exec_order(exec_config)
    # tasks without execution order are no executable
    !haskey(exec_config, EXE_ORDER_KEY) && 
        return say_why ? (false, "Missing $EXE_ORDER_KEY") : false 
    exe_order = exec_config[EXE_ORDER_KEY]
    # tasks with invalid exe_order are no executable
    !(exe_order isa Number) && 
        return say_why ? (false, "Invalid $EXE_ORDER_KEY") : false 

end