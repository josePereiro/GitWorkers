"""
    deb = true just for testing
"""
function worker_loop(path = pwd(); maxwt = 10, verbose = true, 
        iters::Int = typemax(Int), deb = false)

    # checks
    check_gitignores(path)

    # This loop must be run from a worker dir
    worker = find_ownerworker(path)

    for it in 1:iters

        try
            worker_update(worker; verbose = verbose, deb = deb,

                before_push = function(worker)

                    verbose && print_title("MANNAGING TASKS")

                    tasks = findtasks_worker(worker)
                    copytasks = filter((file) -> file |> get_taskroot |> is_copytaskroot, tasks)

                    for copytask in copytasks

                        taskname = get_taskname(copytask)
                        update_kill_status(taskname)
                        update_execution_status(taskname)
                        
                        # This will know what to do with the task depending
                        # of the status
                        mannage_task(copytask; verbose = verbose)

                        update_running_status(taskname)

                        verbose && summary_task(taskname)
                        verbose && println()
                        flush(stdout)

                    end # foreach task                    

                end
            )
            
        catch err
            
            deb && rethrow(err)
            verbose && println(
                "\n------------------- ERROR -------------------\n")
            flush(stdout)
            verbose && showerror(stderr, err, catch_backtrace())
            verbose && println()
            flush(stderr)
                
            err isa InterruptException && return
        end

        flush(stdout)

        # Wait a random time
        sleep(maxwt * rand())
        
    end # for

end