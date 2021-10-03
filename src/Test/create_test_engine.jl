## ---------------------------------------------------------------
function _create_test_engine(testdir; clear_repos = true, clear_scripts = false)
    repodir = joinpath(testdir, "repos")
    clear_repos && _rm(repodir)
    mkpath(repodir)
    url, client_root, server_root = _create_test_repos(repodir)

    # client script
    client_script = joinpath(testdir, "client.jl")
    clear_scripts && rm(client_script; force = true)
    !isfile(client_script) && write(client_script, 
        join([
            "using GitWorkers", 
            "",
            "## ---------------------------------------------------------------",
            "# run to reset all",
            "# GitWorkers._create_test_engine(@__DIR__)",
            "",
            "## ---------------------------------------------------------------",
            "GitWorkers.gw_setup_client(;",
                """\tsys_root = "$(client_root)",""",
                """\turl = "$(url)",""",
            ")"
        ], "\n")
    )

    # server script
    server_script = joinpath(testdir, "server.jl")
    clear_scripts && rm(server_script; force = true)
    write(server_script, 
        join([
            "using GitWorkers", 
            "",
            "## ---------------------------------------------------------------",
            "GitWorkers.run_gitworker_server(;",
                """\tsys_root = "$(server_root)",""",
                """\turl = "$(url)",""",
            ")"
        ], "\n")
    )
    
    @info("GitWorkers setup", url, client_root, server_root)
end