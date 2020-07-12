function update_running_status(taskname)

    # task LOCAL_STATUS
    if !haskey(LOCAL_STATUS, taskname)
        LOCAL_STATUS[taskname] = Dict()
    end

    # running_status
    if !haskey(LOCAL_STATUS[taskname], RUNNING_STATE_KEY)
        LOCAL_STATUS[taskname][RUNNING_STATE_KEY] = Dict()
    end
    running_state = LOCAL_STATUS[taskname][RUNNING_STATE_KEY]

    # update date
    running_state[UPDATE_DATE_KEY] = now()

    procs = filter(is_running, get_taskprocs(taskname))

    if isempty(procs)
        running_state[PID_KEY] = nothing
        running_state[INFO_KEY] = "No process pid request succeeded"
        return running_state[VALUE_KEY] = false
    elseif length(procs) == 1
        running_state[PID_KEY] = procs |> first |> try_getpid 
        running_state[INFO_KEY] = "Process pid request succeeded"
        return running_state[VALUE_KEY] = true
    else
        running_state[PID_KEY] = procs .|> try_getpid
        running_state[INFO_KEY] = "Many process pid request succeeded, this is not ok!!!"
        return running_state[VALUE_KEY] = true
    end
    
end