function _run_log_task_os(taskid; wt = 10.0)
    
    GitWorkers._reg_task_proc(;taskid)
    while true
        # REG PROC
        GitWorkers._reg_task_proc(;taskid)
        GitWorkers._check_duplicated_task_proc(taskid)

        # FLUSH
        flush(stdout)
        flush(stderr)

        # WAIT
        sleep(wt)
    end
end