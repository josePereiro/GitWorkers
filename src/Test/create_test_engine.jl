## ---------------------------------------------------------------
function _create_test_engine(testdir)
    repodir = joinpath(testdir, "repos")
    rm(repodir; force = true, recursive = true)
    mkpath(repodir)
    url, client_home, server_home = _create_test_repos(repodir)

    # client script
    client_scrpt = joinpath(testdir, "client.jl")
    !isfile(client_scrpt) && write(client_scrpt, 
        join([
            "using Gitsh", 
            "",
            "## ---------------------------------------------------------------",
            "# run to reset all",
            "Gitsh._create_test_engine(@__DIR__)",
            "",
            "## ---------------------------------------------------------------",
            "Gitsh.setup_client(;",
                """\tsys_home = "$(client_home)",""",
                """\turl = "$(url)",""", 
                "\tverb = true",
            ")"
        ], "\n")
    )

    # server script
    server_scrpt = joinpath(testdir, "server.jl")
    !isfile(server_scrpt) && write(server_scrpt, 
        join([
            "using Gitsh", 
            "",
            "## ---------------------------------------------------------------",
            "Gitsh.run_server(;",
                """\tsys_home = "$(server_home)",""",
                """\turl = "$(url)",""", 
                "\tverb = true",
            ")"
        ], "\n")
    )
    
    @info("Gitsh setup", url, client_home, server_home)
end