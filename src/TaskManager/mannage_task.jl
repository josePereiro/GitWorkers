"""
    This method determine if the task must be runned or killed based in the information
    in the LOCAL_STATUS.
    Any missing info will thrown an error.
"""
function mannage_task(taskfile; verbose = true)

    taskname = get_taskname(taskfile)
    
    # killing
    kill_state = get_status(taskname, KILL_STATUS_KEY, VALUE_KEY; default = false)
    running_state = get_status(taskname, RUNNING_STATUS_KEY,VALUE_KEY; default = false)
    pids = get_status(taskname, RUNNING_STATUS_KEY, PID_KEY; default = [])
    if running_state && (kill_state || length(pids) > 1)
        kill_taskproc(taskfile; verbose = verbose)
        return
    end

    # Execution 
    exec_state = get_status(taskname, EXEC_STATUS_KEY, VALUE_KEY ; default = false)
    if exec_state
        exec_order = get_config(taskname, EXEC_ORDER_KEY, VALUE_KEY)
        !isnothing(exec_order) && run_taskproc(taskfile, exec_order; verbose = verbose)
        return
    end

end