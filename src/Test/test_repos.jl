# git remote add other /path/to/other/repository
function _create_test_repos(testdir)
    
    # home dirs
    upstream_repo = joinpath(testdir, "upstream_repo")
    client_root = joinpath(testdir, "client_root")
    server_root = joinpath(testdir, "server_root")
    mkpath.([upstream_repo, client_root, server_root])
    
    # create upstream
    @info("setting up upstream")
    dumpfile = joinpath(upstream_repo, "README.md")
    write(dumpfile, "# TEST")
    run(Cmd(["git", "-C", upstream_repo, "--bare", "init"]))
    println("\n")

    # setup gitwr
    url = string("file://", upstream_repo)
    @info("setting up client")
    gw_setup_client(;url, sys_root = client_root)
    println("\n")
    @info("setting up server")
    gw_setup_client(;url, sys_root = server_root)
    println("\n")

    return url, client_root, server_root
end