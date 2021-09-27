function run_server(;
        url::AbstractString,
        sys_root::AbstractString = homedir()
    )

    # ---------------------------------------------------------------
    # SETUP
    setup_gitworker(;url, sys_root)

    # ---------------------------------------------------------------
    while true
    
        try
            # ---------------------------------------------------------------
            # spawn proccess
            println("\n\n")
            @info("Spawing server loop")
            println("\n\n")
            urldir = _urldir()
            script_path = joinpath(@__DIR__, "server_loop_script.jl")
            jlcmd = Cmd(`julia --project=$(urldir) --startup-file=no -- $(script_path) --sys-root=$(sys_root) --url=$(url)`)
            jlcmd = pipeline(jlcmd, stdout=stdout, stderr=stdout)
            run(jlcmd; wait = true)

        catch err
            (err isa InterruptException) && exit()
            print("\n\n")
            printerr(err)
            print("\n\n")
            rethrow(err) # Test
        end

    end
    
end