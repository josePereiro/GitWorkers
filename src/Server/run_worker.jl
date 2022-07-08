function _run_worker(wdir::AbstractString)

    # GLOBALS
    gw = read_toml_file(GitWorker, wdir)
    gw_curr
    isnothing(gw) && error("Unable to load worker, task_dir: ", wdir)
    __run_os = Ref(true)
    __os = nothing

    try

        # WORKER OS
        __os = @async while __run_os[]
                
            # Maintinance
            write_proc_reg(gw)
            safe_killall(gw)

            # sleep
            sleep(3.0)
        end

        # WELCOME
        log_info(gw, 
            "HELLO FROM WORKER";
            runme_file = @__FILE__,
            remote_url = remote_url(gw),
            root_dir = agent_dir(gw),
        )

        # CALL BACKS
        function on_iter(gl)

            log_info(gw, "on_iter")

            
            # some force pushing
            it = state(gl, :loop_iter)
            if iszero(rem(it, 50)) || it == 1
                signal!(gl, :force_sync, true)
            end

            # Maintinance
            write_proc_reg(gw)
            safe_killall(gw)

            # TASKS
            for (_, trt) in collect_tasks!(gw)
                
                # SPAWNS
                do_spwan = !is_running(trt) && has_status(trt, NEW_STATUS)
                do_spwan && _spawn_task_proc(gw, trt)

                # Maintinance
                if !is_running(trt) && has_status(trt, RUNNING_STATUS)
                    write_status(trt, UNKNOWN_STATUS)
                end

            end
            
        end

        function on_pull_success(gl)

            log_info(gw, "on_pull_success")
            
            sync_from_repo(gw)
            
            log_info(gw, "Tasks downloaded!")

        end

        function before_push(gl)

            log_info(gw, "before_push")

            # Upload data
            DM = parent_deamon(gw)
            sync_to_repo(DM, gw) 
            
            log_info(gw, "Data uploaded")


        end

        function on_success(gl)
            
            log_info(gw, "on_success")

            signal!(gl, :force_sync, false)

        end

        ## -----------------------------------------------------
        # WORKER LOOP
        with_logger(gw) do
            
            gl = gitlink(gw)

            run_sync_loop(gl; 
                verbose = true, wdir_clear = true, 
                on_iter, on_pull_success, on_success, before_push
            )

        end

    catch err

        log_error(gw, 
            "AT RUNNING WORKER";
            wid = agent_ider(gw),
            pid = getpid(),
            err = _err_str(err)
        )

        sleep(3.0)
        rethrow(err)

    finally

        # STOP OS
        __run_os[] = false
        isnothing(__os) || wait(__os)

        log_info(gw, 
            "WORKER FINISHED";
            wid = agent_ider(gw), 
            pid = getpid()
        )
        sleep(3.0)

    end

end