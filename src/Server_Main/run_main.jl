function _run_main(;
        url::AbstractString,
        sys_root::AbstractString = homedir()
    )

    # ---------------------------------------------------------------
    # SETUP
    gw_setup_client(;sys_root, url)
    
    # ---------------------------------------------------------------
    # welcome
    _with_server_main_logger() do
        print("\n\n")
        @info("")
        @info("Starting server main process", mainpid = getpid(), time = now())
        print("\n\n")
    end
    
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
            _with_server_main_logger() do
                print("\n\n")
                @info("Spawing server loop", mainpid = getpid(), time = now())
                print("\n\n")
            end
            projdir = Base.active_project()
            script_path = joinpath(@__DIR__, "server_loop_script.jl")
            jlcmd = Base.julia_cmd()
            jlcmd = Cmd(`$(jlcmd) --project=$(projdir) --startup-file=no -- $(script_path) $(sys_root) $(url)`)
            jlcmd = pipeline(jlcmd, stdout=stdout, stderr=stdout)
            run(jlcmd; wait = true)
            
        catch err
            _with_server_main_logger() do
                @error("At server loop", mainpid = getpid(), err = _err_str(err), time = now())
                sleep(3.0) # wait flush
            end
            (err isa InterruptException) && exit()
        end

    end

    # ---------------------------------------------------------------
    exit()
    
end