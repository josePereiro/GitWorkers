function update_running_status(taskname)

    procs = filter(is_running, get_taskprocs(taskname))

    if isempty(procs)
        info = "No process pid request succeeded"
        pid = nothing
        running_state = false
    elseif length(procs) == 1
        info = "Process pid request succeeded"
        pid = procs |> first |> try_getpid 
        running_state = true
    else
        info = "Many process pid request succeeded, this is not ok!!!"
        pid = procs .|> try_getpid
        running_state = true
    end

    set_status(now(), taskname, RUNNING_STATUS_KEY, UPDATE_DATE_KEY)
    set_status(info, taskname, RUNNING_STATUS_KEY, INFO_KEY)
    set_status(pid, taskname, RUNNING_STATUS_KEY, PID_KEY)
    return set_status(running_state, taskname, RUNNING_STATUS_KEY, VALUE_KEY)

end