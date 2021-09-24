function run_server(;
        url::AbstractString,
        sys_root::AbstractString = homedir(),
        niters = typemax(Int)
    )

    # ---------------------------------------------------------------
    # SETUP
    setup_gitworker(;url, sys_root)
    
    # ---------------------------------------------------------------
    # SERVER GLOBALS
    repodir = _repodir()

    # ---------------------------------------------------------------
    # sync loop
    server_ios = [stdout]
    sync_msg = ""
    iterfrec = 10.0
    last_push_time = 0.0
    pull_out = ""
    push_out = ""
    
    # ---------------------------------------------------------------
    # setup
    
    # ---------------------------------------------------------------
    # SERVER LOOP
    for iter in 1:niters

        try

            println("\n------------------------------------------------------")
            println("Server loop, iter: ", iter)

            # ------------------------------------------------------
            # tokens
            fail_token = _gen_id()
            success_token = _gen_id()

            # ------------------------------------------------------
            # pull
            while true
                _, pull_out = _call_sync_script(;
                    repodir, url, 
                    pull = true,
                    force_clonning = false, 
                    push = false,
                    success_token, fail_token,
                    ios = server_ios,
                    detach = false
                )
                iterfrec = _load_iterfrec()
                elap_time = time() - last_push_time
                (elap_time > iterfrec) && break
                println("\nJust listening, next iter at: ", round(max(0.0, iterfrec - elap_time)), " second(s)")
                sleep(_GITWR_ITER_FRACWT)
            end
            contains(pull_out, fail_token) && continue

            # ------------------------------------------------------
            # repo routine
            println("\nrunning repo routines")
            _uprepo_rtdir = _repodir(_GITWR_UPREPO_RTDIR)
            _eval_routines(_uprepo_rtdir)

            # ------------------------------------------------------
            # push
            sync_msg = "Sync iter: $(iter) time :$(now())"
            _, push_out = _call_sync_script(;
                repodir, url, 
                pull = false,
                force_clonning = false,
                push = true,
                commit_msg = sync_msg,
                success_token, fail_token,
                ios = server_ios,
                detach = false
            )
            contains(push_out, success_token) ? (last_push_time = time()) : continue

            # ------------------------------------------------------
            # local routine
            println("\nrunning local routines")
            _uplocal_rtdir = _repodir(_GITWR_UPLOCAL_RTDIR)
            _eval_routines(_uplocal_rtdir)

        catch err
            rethrow(err)
            # err isa InterruptException && rethrow(err)
            # @warn("Error", err)
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