function _main_loop(sys_root, url)

    # ---------------------------------------------------------------
    # welcome
    
    print("\n\n")
    @info("")
    @info("Starting server main process", mainpid = getpid(), time = now())
    print("\n\n")
    
    # ---------------------------------------------------------------
    # Server Os
    _reg_server_main_proc()
    @async _run_server_main_os()

    # ---------------------------------------------------------------
    # make process resiliant
    while true
    
        try
            # ---------------------------------------------------------------
            # reg main
            _reg_server_main_proc()

            # ---------------------------------------------------------------
            # spawn proccess
            print("\n\n")
            @info("Spawing server loop", mainpid = getpid(), time = now())
            print("\n\n")

            projdir = Base.active_project()
            script_path = joinpath(@__DIR__, "server_loop_script.jl")
            jlcmd = Base.julia_cmd()
            jlcmd = Cmd(`$(jlcmd) --project=$(projdir) --startup-file=no -- $(script_path) $(sys_root) $(url)`)
            jlcmd = pipeline(jlcmd, stdout=stdout, stderr=stdout)
            run(jlcmd; wait = true)
            
            # ---------------------------------------------------------------
            # spawn proccess
            _reset_server_main_listen_wait()
            
        catch err
                
            @error("At server loop", mainpid = getpid(), err = _err_str(err), time = now())
            _server_main_listen_wait()
            (err isa InterruptException) && exit()
        end

    end

    # ---------------------------------------------------------------
    exit()

end