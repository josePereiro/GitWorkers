function run_gitworker_server(;
        url::AbstractString,
        sys_root::AbstractString = homedir()
    )

    # ---------------------------------------------------------------
    # SETUP
    gw_setup_client(;url, sys_root)
    
    # ---------------------------------------------------------------
    # check
    _reg_server_main_proc()
    _clear_invalid_procs_regs()
    _check_duplicated_server_main_proc()

    # ---------------------------------------------------------------
    # Server Os
    _GW_ISRUNNING = true
    @async while _GW_ISRUNNING
        # handle proc reg
        _reg_server_main_proc()
        _check_duplicated_server_main_proc()
        _clear_invalid_procs_regs()

        sleep(10.0)
    end

    # ---------------------------------------------------------------
    # make process resiliant
    while true
    
        try
            # ---------------------------------------------------------------
            # spawn proccess
            println("\n\n")
            @info("Spawing server loop")
            println("\n\n")
            projdir = Base.active_project()
            script_path = joinpath(@__DIR__, "server_loop_script.jl")
            jlcmd = Base.julia_cmd()
            jlcmd = Cmd(`$(jlcmd) --project=$(projdir) --startup-file=no -- $(script_path) $(sys_root) $(url)`)
            jlcmd = pipeline(jlcmd, stdout=stdout, stderr=stdout)
            run(jlcmd; wait = true)
            
        catch err
            (err isa InterruptException) && exit()
            print("\n\n")
            _printerr(err)
            print("\n\n")
        end

    end

    # ---------------------------------------------------------------
    _GW_ISRUNNING = false
    exit()
    
end