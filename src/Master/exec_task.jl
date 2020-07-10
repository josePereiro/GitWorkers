"""
    This function will set a given task (or path ownertask) as executable.
    Then will push_master
"""
function exec_task(path = pwd())
    ownertask = find_ownertask(path)
    taskroot = ownertask |> get_taskroot

    println()
    println("------------------ PULLING ORIGIN -----------------")
    println()

    # pulling to have an the updated
    !git_pull() && error("Fail to pull")

    println()
    println("------------------ PREPARING TASK -----------------")
    println("task: ", relpath_worker(taskroot))

    # Config file
    # Kill sign
    write_task_exec_config(ownertask, KILL_SIGN_KEY, "NOT_$KILL_SIGN")
    write_task_exec_status(ownertask, KILL_ORDER_STATE_KEY, false)
    write_task_exec_status(ownertask, KILL_ORDER_STATE_INFO_KEY, "Task executed")
    
    # Exe order
    exe_order = read_task_exec_config(ownertask, EXE_ORDER_KEY)
    isnothing(exe_order) && (exe_order = 0)
    last_exe_order = read_task_exec_status(ownertask, LAST_EXE_ORDER_KEY)
    isnothing(last_exe_order) && (last_exe_order = 0)

    exe_order = max(exe_order, last_exe_order) + 1
    write_task_exec_config(ownertask, EXE_ORDER_KEY, exe_order)

    println("new exec order: $exe_order")

    println()
    println("------------------ PUSHING MASTER -----------------")
    println()

    # pushing to master
    push_master()


    println()
    println("------------------ READING LOGS -----------------")
    println()
    follow_exec(init_margin = 0)

end