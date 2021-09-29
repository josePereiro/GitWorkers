# ---------------------------------------------------------------
function _server_loop()

    # ---------------------------------------------------------------
    # SERVER GLOBALS
    repodir = _repodir()
    url = _get_url()

    # ---------------------------------------------------------------
    # sync loop
    server_ios = [stdout]
    sync_msg = ""
    iterfrec = _get_iterfrec()
    last_push_time = 0.0
    success = false
    push_out = ""
    
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
                    ios = server_ios
                )

                # iter control
                # iterfrec = _get_iterfrec()
                # elap_time = time() - last_push_time
                # _istime = (elap_time > iterfrec) 
                # _istime && break                

                # push flag
                _check_pushflag() && break

                # println("\nJust listening, next iter at: ", round(max(0.0, iterfrec - elap_time)), " second(s)")
                println("\nJust listening")
                sleep(_GITWR_ITER_FRACWT)
            end
            !success && continue

            # ------------------------------------------------------
            # get iter
            iter = _get_curriter()
            
            println("\n------------------------------------------------------")
            println("Server loop, iter: ", iter)

            # ------------------------------------------------------
            # repo routine
            !_check_standby_sig() && let
                println("\nrunning repo routines")
                _uprepo_rtdir = _repodir(_GITWR_UPREPO_RTDIR)
                _eval_routines(_uprepo_rtdir)
            end

            # ------------------------------------------------------
            # sync tasks
            _sync_task_data()

            # ------------------------------------------------------
            # update sysfiles
            _update_curriter()
            _update_resetsig()
            _update_killsigs()

            # ------------------------------------------------------
            # push
            sync_msg = "Sync iter: $(iter) time :$(now())"
            success = _gw_push(;
                commit_msg = sync_msg, 
                repodir, url,
                success_token, fail_token, 
                ios
            )
            !success && exit() # Test
            success ? (last_push_time = time()) : continue

            # ------------------------------------------------------
            # local routine
            !_check_standby_sig() && let
                println("\nrunning local routines")
                _uplocal_rtdir = _repodir(_GITWR_UPLOCAL_RTDIR)
                _eval_routines(_uplocal_rtdir)
            end

            # ------------------------------------------------------
            # handle signals
            _exec_killsigs()
            _exec_resetsig()


        catch err
            rethrow(err)
            # err isa InterruptException && rethrow(err)
            printerr(err)
            # println()
            # Test
            # rethrow(err) 
        end

        # loop control
        # TODO: connect with config
        # sleep(5.0)

        println("\n")

    end # server loop end
end