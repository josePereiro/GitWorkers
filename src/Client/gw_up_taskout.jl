function gw_up_taskout(taskid = gw_last_task();
        sync = true, verb = false, tout = 60.0
    )
    isempty(taskid) && return ""

    # sync
    sync && _gw_full_sync(; tout, verb)
    
    # out_file
    out_file = _repo_task_out_file(taskid)
    println("taskout:")
    println(isfile(out_file) ? out_file : "")
end
