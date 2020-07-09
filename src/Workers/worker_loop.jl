
function worker_loop(maxwt = 10)

    while true

        try

            # Wait a random time 
            sleep(maxwt * rand())

            println()
            println("------------------- SYNC REPO -------------------")
            println()

            # ------------------- FORCE "PULL" -------------------
            # This force the local repo to be equal to the origin
            # This is a fundamental design desition. This way the 
            # worker code is more robust        
            !git_pull(force = true) && continue

            # ------------------- UPDATE REPO LOCALS -------------------
            # The local directories of the repo will be overwritten by
            # its peers in the copy
            # This implements downstream -> upstream comunication 
            sync_taskdirs(COPY_ID, LOCAL_FOLDER_NAME)

            # TODO: introduce checks before pushing
            # ------------------- PUSH ORIGINS -------------------
            git_add_all() && 
            git_commit(get_worker_name() * " update") &&
            git_push()
            
            # ------------------- UPDATE LOCAL ORIGINS -------------------
            # The origin directories of the copy will be overwritten by
            # its peers in the repo
            # This implements upstream -> downstream comunication 
            sync_taskdirs(REPO_ID, ORIGIN_FOLDER_NAME)
            

            println()
            println("------------------- MANAGING TASKS -------------------")
            println()

            tasks = find_tasks()
            copytasks = filter((file) -> file |> get_taskroot |> is_copytaskroot, tasks)
            for copytask in copytasks
                
                
                println("$(relpath(copytask))")
                
                
                # ------------------- KILL RUNNING TASK -------------------
                # If the kill state is `true` and the task is running, the process
                # executing the task will be kill
                killable = get_kill_config(copytask)
                killable && is_taskrunning(copytask) && kill_taskproc(copytask)
                println("killable: ", killable)
                
                
                # ------------------- LAUNCHING TASK -------------------
                # If the kill state is `true` and the task is running, the process
                # executing the task will be kill
                executable = get_executable_config(copytask)
                executable && !is_taskrunning(copytask) && !killable && run_taskproc(copytask)
                println("executable: ", executable)

                println("is_running: ", is_taskrunning(copytask))
                flush(stdout)

                
            end # foreach task

        catch err
            err isa InterruptException && rethrow(err)
            println(err)
        end
        
    end # while
end