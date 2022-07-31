function gw_ping(gw::GitWorker = gw_curr(); 
        npings = 10, 
        verbose = true,
        onping::Function = () -> nothing
    )

    GitLinks.ping(gitlink(gw); npings, verbose, onping)

    return nothing
end