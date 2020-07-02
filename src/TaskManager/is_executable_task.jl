"""
    Returns true if the task must be executed
"""
function is_executable_task(taskfile)

    # ------------------- CHECK IF COPY -------------------
    # Only tasks in a copy dir must be executed
    !is_copytaskroot(taskfile |> get_taskroot) && return false

    # ------------------- CHECK IF RUNNING -------------------
    # If is running any execution order will be ignored till
    # task finished or die
    haskey(running_tasks, taskfile) && return false

    # ------------------- EXEC-CONFIG -------------------
    exec_config = read_task_exec_config_toml(taskfile)
    # task with missing exec_config are no executable
    isnothing(exec_config) && return false

    # ------------------- EXEC_ORDER -------------------
    exe_order = get_exec_order(exec_config)
    # tasks without execution order are no executable
    !haskey(exec_config, EXE_ORDER_KEY) && return false
    exe_order = exec_config[EXE_ORDER_KEY]
    # tasks with invalid exe_order are no executable
    !(exe_order isa Number) && return false

    # ------------------- EXEC-STATUS -------------------
    exec_status = read_task_exec_status_toml(taskfile)
    # Tasks without exec_status file are executable
    isnothing(exec_status) && return true
    # tasks without last execution order are executable
    !haskey(exec_status, LAST_EXE_ORDER_KEY) && return true
    last_exe_order = exec_status[LAST_EXE_ORDER_KEY]
    # tasks with invalid last execution order are executable
    !(last_exe_order isa Number) && return true

    # ------------------- COMPARE-ORDERS -------------------
    # A task with a newer execution order will be executable
    (exe_order > last_exe_order) && return true

    # by default task are not executable, just in case something 
    # wire happend
    return false
end