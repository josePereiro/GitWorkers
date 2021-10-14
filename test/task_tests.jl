function gitworker_tasks_tests()

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
        GitWorkers.gw_setup_gitworker(;
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

        # gw spawn
        rm(dummy_file; force = true)
        @assert !isfile(dummy_file)

        # The task spawn system migth fail
        for _ in 1:5
            expr = quote 
                begin 
                    GitWorkers._rm($(dummy_file))
                    @assert !isfile($(dummy_file))
                    GitWorkers._mkpath(dirname($(dummy_file)))
                    write($(dummy_file), $(token))
                    println("jlexpr task test ")
                end
            end
            gw_spawn(expr; verb = false, follow = true, tout = 60.0, wt = 5.0)

            isfile(dummy_file) && break
        end
        
        @test isfile(dummy_file)
        @test contains(read(dummy_file, String), token)

        # gw bash
        rm(dummy_file; force = true)
        @assert !isfile(dummy_file)

        # The task spawn system migth fail
        for _ in 1:5
            src = """echo "bash str task test"; echo '$(token)' > '$(dummy_file)'"""
            gw_bash(src; verb = false, follow = true, tout = 60.0, wt = 5.0)
            isfile(dummy_file) && break
        end

        @test isfile(dummy_file)
        @test contains(read(dummy_file, String), token)

        # gw julia
        rm(dummy_file; force = true)
        @assert !isfile(dummy_file)
        
        # The task spawn system migth fail
        for _ in 1:5
            src = """println("julia str task test"); write("$(dummy_file)", "$(token)") """
            gw_julia(src; verb = false, follow = true, tout = 60.0, wt = 5.0)
            isfile(dummy_file) && break
        end

        @test isfile(dummy_file)
        @test contains(read(dummy_file, String), token)

        # ---------------------------------------------------------------------
        println("\n\n")
        println("-"^60)
        println("Testing killsig")
        println("\n\n")
        
        gw_pull(;force_clonning = true, verb = false)

        tout = 10*60
        verb = false
        # The task spawn system migth fail
        for _ in 1:5
            gw_test_task(tout; follow = false)
        end
        sleep(15)


        for it in 1:15

            println("waiting, curriter: ", GitWorkers._get_curriter())
            timeout = !GitWorkers._waitfor_till_next_iter(;verb, tout)
            @test !timeout

            runningtasks = GitWorkers._filterdir(GitWorkers._repo_procs_dir()) do file
                println("procreg: ", file)
                GitWorkers._is_task_procreg(file)
            end

            notasks = length(runningtasks)
            if notasks > 0

                procreg = first(runningtasks)
                println("to kill : ", procreg)

                pid, tag, _ = GitWorkers._parse_procreg_name(procreg)
                @test !isempty(pid)
                @test !isempty(tag)
                @test tag == GitWorkers._GW_TASK_PROC_TAG

                gw_send_killsig(pid; tries = 15, unsafe = false, verb = false, tout = 120)

                @test !GitWorkers._validate_proc(procreg)
                break

            end

            sleep(10)
             
            if it == 15
                @test notasks == 0
            end
            
        end # for it in 1:15

    finally
        
        # kill server
        server_pid = isnothing(server_proc) ? -1 : GitWorkers._try_getpid(server_proc)
        @show server_pid
        GitWorkers._kill_all_procs(GitWorkers._repo_procs_dir())
        GitWorkers._force_kill(server_pid)

		GitWorkers._rm(test_dir)
        
	end
end

let
    for t in 1:5
        println("\n"^5)
        gitworker_tasks_tests()
        println("\n"^5)
    end
end