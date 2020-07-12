"""
    This method determine if the task must be runned or killed based in the information
    in the LOCAL_STATUS.
    Any missing info will thrown an error.
"""
function mannage_task(taskfile; verbose = true)

    taskname = get_taskname(taskfile)

    local_status = LOCAL_STATUS[taskname]
    
    # killing
    kill_state = local_status[KILL_STATE_KEY][VALUE_KEY]
    running_state = local_status[RUNNING_STATE_KEY][VALUE_KEY]
    pids = local_status[RUNNING_STATE_KEY][PID_KEY]
    if running_state && (kill_state || length(pids) > 1)
        kill_taskproc(taskfile)
        return
    end

    # Execution 
    exec_state = local_status[EXECUTION_STATE_KEY][VALUE_KEY]
    if exec_state
        origin_config = ORIGIN_CONFIG[taskname]
        exec_order = origin_config[EXE_ORDER_KEY][VALUE_KEY]
        run_taskproc(taskfile, exec_order; verbose = verbose)
        return
    end

end