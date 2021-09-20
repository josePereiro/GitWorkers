function run_server(;
        url::AbstractString,
        sys_home::AbstractString = homedir(),
        niters = typemax(Int)
    )

    # ---------------------------------------------------------------
    # SYS GLOBALS
    _set_url!(url)
    _set_root!(sys_home)
    
    # ---------------------------------------------------------------
    # SERVER GLOBALS
    urldir = _gitwr_urldir()

    # ---------------------------------------------------------------
    # sync loop
    # TODO: connect to config
    force_clonning = false
    server_ios = [stdout]
    sync_msg = ""
    sync_startup = String[]
    buff_file = _gitwr_tempfile()


    # ---------------------------------------------------------------
    # Jobs
    # exec cmd
    function _exec_cmds()
        for cmdfile in _find_cmds()
            _exec_cmd(cmdfile; verb = false)
        end
    end

    # ---------------------------------------------------------------
    # SERVER LOOP
    for iter in 1:niters

        try

            # Sync gw
            sync_msg = "Sync iter: $(iter) time $(iter):$(now())"
            _gwsync(;
                msg = sync_msg,
                startup = sync_startup, 
                ios = server_ios, 
                force_clonning,
                buff_file
            )

            # exec cmd
            for cmdfile in _find_cmds()
                _exec_cmd(cmdfile; verb = false)
            end

            # wait engine
            sleep(5.0)

        catch err
            err isa InterruptException && rethrow(err)
            @warn("Error", err)
            println()
            # Test
            # rethrow(err) 
        end

    end # server loop end
    
end