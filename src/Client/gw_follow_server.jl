function gw_follow_server(; tout = Inf)
    gw = gw_curr()
    download(gitlink(gw)) # first sync

    rgw = repo_agent(gw)
    rdm = parent_deamon(rgw)

    @info("Following server")
    _pull_and_listen(gw, rdm; tout) 

end