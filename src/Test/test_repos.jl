# git remote add other /path/to/other/repository
function _create_test_repos(testdir)
    
    # home dirs
    upstream_home = joinpath(testdir, "upstream_home")
    client_root = joinpath(testdir, "client_root")
    server_home = joinpath(testdir, "server_home")
    mkpath.([upstream_home, client_root, server_home])
    
    # create upstream
    @info("setting up upstream")
    dumpfile = joinpath(upstream_home, "README.md")
    write(dumpfile, "# TEST")
    run(Cmd(["git", "-C", upstream_home, "--bare", "init"]))
    println("\n")

    # setup gitwr
    url = string("file://", upstream_home)
    @info("setting up client")
    setup_gitworker(;url, sys_root = client_root)
    println("\n")
    @info("setting up server")
    setup_gitworker(;url, sys_root = server_home)
    println("\n")

    return url, client_root, server_home
end