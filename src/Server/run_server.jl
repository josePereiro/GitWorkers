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
    repodir = _urldir()

    # ---------------------------------------------------------------
    # sync loop
    # TODO: connect to config
    
    server_ios = [stdout]
    sync_msg = ""
    
    # ---------------------------------------------------------------
    # setup
    
    # ---------------------------------------------------------------
    # SERVER LOOP
    for iter in 1:niters

        try

            # ------------------------------------------------------
            fail_token = _gen_id()
            success_token = _gen_id()

            # ------------------------------------------------------
            # pull
            _, pull_out = _call_sync_script(;
                repodir, url, 
                pull = true,
                force_clonning = false, 
                push = false,
                success_token, fail_token,
                ios = server_ios,
                detach = false
            )
            contains(pull_out, fail_token) && continue

            # ------------------------------------------------------
            # global routine
            _global_routines_dir = _globaldir(".global_routines")
            _exec_routines(_global_routines_dir; mod0 = Main)

            # ------------------------------------------------------
            # push
            sync_msg = "Sync iter: $(iter) time :$(now())"
            for att in 1:5
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
                contains(push_out, success_token) && break
            end

            # ------------------------------------------------------
            # local routine
            _local_routines_dir = _globaldir(".local_routines")
            _exec_routines(_local_routines_dir; mod0 = Main)

        catch err
            err isa InterruptException && rethrow(err)
            @warn("Error", err)
            println()
            # Test
            # rethrow(err) 
        end

        # loop control
        # TODO: connect with global
        sleep(5.0)

    end # server loop end
    
end