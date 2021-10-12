# ---------------------------------------------------------------
function _server_loop()

    # ---------------------------------------------------------------
    # SERVER GLOBALS
    repodir = _repodir()
    url = _get_url()

    ## ------------------------------------------------------------------
    # OS
    @async _run_server_loop_os()

    # ---------------------------------------------------------------
    # welcome
    print("\n\n")
    @info("")
    @info("Starting server loop", looppid = getpid(), time = now())
    print("\n\n")
    
    # ---------------------------------------------------------------
    # sync loop
    verb = true
    sync_msg = ""
    success = false

    # ---------------------------------------------------------------
    # feedback
    function _sync_logging(action, fail_token, clonning_token)
        function (out)
            if contains(out, fail_token)

                print("\n\n")
                @warn("Fail token detected", action, time = now(), out)
                print("\n\n")

            elseif contains(out, clonning_token)

                print("\n\n")
                @warn("Clonning token detected", action, time = now(), out)
                print("\n\n")

            end
        end
    end

    # ---------------------------------------------------------------
    # SERVER LOOP
    while true

        try
            # ------------------------------------------------------
            # iter tokens
            fail_token = _gen_id()
            success_token = _gen_id()
            clonning_token = _gen_id()

            # ------------------------------------------------------
            # stand by loop
            while true

                # ------------------------------------------------------
                # sys maintinance
                _reg_server_loop_proc()
                _clear_invalid_procs_regs()
                _check_duplicated_server_main_proc()
                _check_duplicated_server_loop_proc()
                _clear_local_signals()
                _clear_local_tasks()
                
                # ------------------------------------------------------
                # pull
                success = _gw_pull(;
                    repodir, url,
                    success_token, fail_token, clonning_token,
                    force_clonning = false, 
                    feedback = _sync_logging(:pulling, fail_token, clonning_token),
                    verb
                )
                
                # wait
                _listen_wait()

                # ------------------------------------------------------
                # loopcontrol
                # push flag
                _check_pushflag() && break

            end
            _reset_listen_wait()
            !success && continue

            # ------------------------------------------------------
            # get iter
            iter = _get_curriter()
        
            print("\n\n")
            @info("")
            @info("Server loop", iter, looppid = getpid(), time = now())
            print("\n\n")

            # ------------------------------------------------------
            # download data
            _download_signals()
            _download_tasks()

            # ------------------------------------------------------
            # upload data
            _upload_tasks_outs()
            _upload_procs()
            _exec_up_serverlogs_sig()

            # ------------------------------------------------------
            # repo maintinance
            _clear_pushflag()
            _clear_repo_signals()
            _clear_repo_tasks()

            # ------------------------------------------------------
            # push
            _update_curriter()
            sync_msg = "Sync iter: $(iter) time :$(now())"
            success = _gw_push(;
                commit_msg = sync_msg, 
                repodir, url,
                success_token, fail_token, clonning_token,
                feedback = _sync_logging(:pushing, fail_token, clonning_token),
                verb
            )

            # ------------------------------------------------------
            # exec tasks
            if success
                println("\nexec tasks")
                _spawn_long_tasks()
            end

            # ------------------------------------------------------
            # exec signals
            _exec_killsigs()
            _exec_resetsig()

        catch err
            
            print("\n\n")
            @error("At server loop", looppid = getpid(), time = now(), err = _err_str(err))
            print("\n\n")
            sleep(3.0) # wait flush

            exit()
        end

        println("\n")

    end # server loop end
end