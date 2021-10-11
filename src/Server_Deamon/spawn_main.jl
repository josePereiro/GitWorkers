function _spawn_main(;sys_root, url, 
        sync = false
    )

    try
        
        # ---------------------------------------------------------------
        # setup
        _local_setup(;sys_root, url)
        
        # ---------------------------------------------------------------
        # check if main is already running
        noprocs = _no_proc_running(_GW_SERVER_MAIN_PROC_TAG)
        if (noprocs > 0)

            _with_server_deamon_logger() do
                print("\n\n")
                @info("Server main is running ", deamonpid = getpid(), url, time = now())
                print("\n\n")
            end

            return
        end

        # ---------------------------------------------------------------
        # spawn proccess
        _with_server_deamon_logger() do
            print("\n\n")
            @info("Spawing server main", deamonpid = getpid(), url, time = now())
            print("\n\n")
        end

        # TODO: handle main project
        projdir = Base.active_project()
        script_path = joinpath(@__DIR__, "server_main_script.jl")
        jlcmd = Base.julia_cmd()
        jlcmd = Cmd(`$(jlcmd) --project=$(projdir) --startup-file=no -- $(script_path) $(sys_root) $(url)`; detach = false)
        run(jlcmd; wait = sync)
        
    catch err
        _with_server_deamon_logger() do
            print("\n\n")
            @error("At server loop", mainpid = getpid(), err = _err_str(err), time = now())
            print("\n\n")
            sleep(3.0) # wait flush
        end
        (err isa InterruptException) && exit()
    end

end