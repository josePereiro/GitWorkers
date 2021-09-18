# git remote add other /path/to/other/repository
function _create_test_repos(testdir)
    
    # home dirs
    upstream_home = joinpath(testdir, "upstream_home")
    client_home = joinpath(testdir, "client_home")
    server_home = joinpath(testdir, "server_home")
    mkpath.([upstream_home, client_home, server_home])
    
    # create upstream
    @info("setting up upstream")
    dumpfile = joinpath(upstream_home, "README.md")
    write(dumpfile, "# TEST")
    run(Cmd(["git", "-C", upstream_home, "--bare", "init"]))
    println("\n")

    # setup gitwr
    url = string("file://", upstream_home)
    @info("setting up client")
    setup_gitworker(;url, sys_home = client_home)
    println("\n")
    @info("setting up server")
    setup_gitworker(;url, sys_home = server_home)
    println("\n")

    return url, client_home, server_home
end