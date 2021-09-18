function run_server(;
        url::AbstractString,
        sys_home::AbstractString = homedir(),
        verb::Bool=false, 
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


    # ---------------------------------------------------------------
    # SERVER LOOP
    for iter in 1:niters
        
        # ---------------------------------------------------------------
        sync_msg = "Sync iter: $(iter) time $(iter):$(now())"
        
        try
            # SYNCHRONIZATION FUN
            function _on_sync()
                
                # basi maintinance

                # copy stage to urldir
                stagedir = _gitwr_stagedir()
                for (_root, _, _files) in walkdir(stagedir)
                    for name in _files
                        stage_file = joinpath(_root, name)
                        _on_mtime_event(stage_file; dofirst = true) do
                            wdir_file = replace(stage_file, stagedir => urldir)
                            _cp(stage_file, wdir_file)
                        end
                    end
                end
            end

            _try_sync(_on_sync; 
                startup = sync_startup, 
                msg = sync_msg, 
                ios = server_ios, 
                url, buff_file, repo_dir, 
                force_clonning
            )
    

        catch err
            err isa InterruptException && rethrow(err)
            @warn("Error", err)
            println()
            rethrow(err)
        end

        # wait engine

    end # server loop end
    
end