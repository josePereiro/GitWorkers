function kill_task(path = pwd(); verbose = true, deb = false)
    ownertask = find_ownertask(path)
    taskroot = ownertask |> get_taskroot

    if !deb
        verbose && println()
        verbose && println("------------------ PULLING ORIGIN -----------------")
        verbose && println()

        # pulling to have an the updated
        git_pull()
    end

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
    master_update()


    println()
    println("------------------ READING LOGS -----------------")
    println()
    follow_exec(init_margin = 0)
    
end