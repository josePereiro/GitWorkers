function kill_task(path = pwd())
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
    write_task_exec_config(ownertask, KILL_SIGN_KEY, KILL_SIGN)
    println("kill sign: ", KILL_SIGN)

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