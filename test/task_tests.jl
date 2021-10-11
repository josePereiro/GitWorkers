let

    test_dir = mktempdir(;prefix = "gw_")
    server_proc = nothing

    try
        GitWorkers._rm(test_dir)
        mkpath(test_dir)
        cd(test_dir)

        url, client_root, server_root = GitWorkers._create_test_repos(test_dir)

        # launch server
        proj = Base.active_project()
        server_proc = run(`$(Base.julia_cmd()) --project=$(proj) --startup-file=no -e "import GitWorkers; GitWorkers._run_main(;sys_root = \"$(server_root)\", url = \"$(url)\"); exit()"`, wait = false)
        server_pid = GitWorkers._try_getpid(server_proc)
        @show server_pid
        sleep(10) # wait for responce

        # ---------------------------------------------------------------------
        # setup client
        GitWorkers.gw_setup_client(;
            sys_root = client_root,
            url,
        )

        # ---------------------------------------------------------------------
        println("\n\n")
        println("-"^60)
        println("Simple task test")
        println("\n\n")
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

        # ---------------------------------------------------------------------
        println("\n\n")
        println("-"^60)
        println("Testing killsig")
        println("\n\n")
        gw_pull(;force_clonning = true, verb = false)
        
        @show GitWorkers._repo_procs_dir()
        runningtasks = GitWorkers._filterdir(GitWorkers._repo_procs_dir()) do file
            println("procreg: ", file)
            GitWorkers._is_task_procreg(file)
        end

        tout = 10*60
        verb = false
        gw_test_task(tout; follow = false)
        sleep(15)

        for it in 1:15
            println("waiting, curriter: ", GitWorkers._get_curriter())
            timeout = !GitWorkers._waitfor_till_next_iter(;verb, tout)

            runningtasks = GitWorkers._filterdir(GitWorkers._repo_procs_dir()) do file
                println("procreg: ", file)
                GitWorkers._is_task_procreg(file)
            end

            notasks = length(runningtasks)
            @test notasks == 0 || notasks == 1
            
            if notasks == 1

                procreg = first(runningtasks)
                println("to kill : ", procreg)

                pid, tag, _ = GitWorkers._parse_procreg_name(procreg)
                @test !isempty(pid)
                @test !isempty(tag)
                @test tag == GitWorkers._GW_TASK_PROC_TAG

                gw_send_killsig(pid)

                @test true
                break

            end

            sleep(10)

            @test it != 5
        end


    finally
        
        # kill server
        server_pid = isnothing(server_proc) ? -1 : GitWorkers._try_getpid(server_proc)
        @show server_pid
        GitWorkers._force_kill(server_pid)

		GitWorkers._rm(test_dir)
        
	end
end
