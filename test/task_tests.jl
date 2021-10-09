let

    test_dir = joinpath(tempdir(), "gitworkers_testland")
    server_proc = nothing

    try
        GitWorkers._rm(test_dir)
        mkpath(test_dir)

        url, client_root, server_root = GitWorkers._create_test_repos(test_dir)

        # launch server
        proj = Base.active_project()
        server_proc = run(`$(Base.julia_cmd()) --project=$(proj) --startup-file=no -e "import GitWorkers; GitWorkers._run_main(;sys_root = \"$(server_root)\", url = \"$(url)\"); exit()"`, wait = false)
        server_pid = GitWorkers._try_getpid(server_proc)
        @show server_pid
        sleep(10) # wait for responce

        # client
        GitWorkers.gw_setup_client(;
            sys_root = client_root,
            url,
        )
        
        token = string(rand(UInt))
        dummy_file = joinpath(test_dir, "._gw_test_dummy")

        expr = quote 
            begin 
                GitWorkers._rm($(dummy_file))
                @assert !isfile($(dummy_file))
                GitWorkers._mkpath(dirname($(dummy_file)))
                write($(dummy_file), $(token))
                println("Hiiiii from server proc ", getpid())
            end
        end
        GitWorkers._gw_spawn(expr; verb = true, follow = true, tout = 120.0, wt = 3.0)
        
        @test isfile(dummy_file)
        @test isfile(dummy_file) && (read(dummy_file, String) == token)

    finally
        
        # kill server
        server_pid = isnothing(server_proc) ? -1 : GitWorkers._try_getpid(server_proc)
        @show server_pid
        GitWorkers._force_kill(server_pid)

		GitWorkers._rm(test_dir)
        
	end
end
