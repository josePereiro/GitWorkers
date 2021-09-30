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
    # sync loop
    verb = true
    sync_msg = ""
    success = false
    
    # ---------------------------------------------------------------
    # SERVER LOOP
    while true

        try
            # ------------------------------------------------------
            # iter tokens
            fail_token = _gen_id()
            success_token = _gen_id()

            # ------------------------------------------------------
            # pull loop
            while true
                success = _gw_pull(;
                    repodir, url,
                    success_token, fail_token,
                    force_clonning = false, 
                    verb
                )

                # loopcontrol
                # push flag
                _check_pushflag() && break

                # wait
                _listen_wait()
            end
            _reset_listen_wait()
            !success && continue

            # ------------------------------------------------------
            # get iter
            iter = _get_curriter()
            
            println("\n------------------------------------------------------")
            println("Server loop, iter: ", iter)

            # ------------------------------------------------------
            # download data
            _download_signals()
            _download_tasks()

            # ------------------------------------------------------
            # upload data
            _upload_logs()
            _upload_procs()

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
                success_token, fail_token, 
                verb
            )
            !success && continue

            # ------------------------------------------------------
            # exec tasks
            println("\nexec tasks")
            _spawn_long_tasks()

            # ------------------------------------------------------
            # exec signals
            _exec_killsigs()
            _exec_resetsig()
            
            # ------------------------------------------------------
            # sys maintinance
            _reg_server_loop_proc()
            _clear_invalid_procs_regs()
            _check_duplicated_server_main_proc()
            _check_duplicated_server_loop_proc()

        catch err
            err isa InterruptException && rethrow(err)
            print("\n\n")
            _printerr(err)
            print("\n\n")
            
            # Dev
            rethrow(err)
        end

        # loop control
        # TODO: connect with config
        # sleep(5.0)

        println("\n")

    end # server loop end
end