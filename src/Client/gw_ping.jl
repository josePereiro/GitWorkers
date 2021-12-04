function gw_ping(gw::GitWorker = gw_curr(); 
        tout = 120.0, 
        verbose = false,
        onping::Function = () -> nothing
    )

    GitLinks.ping(gitlink(gw); tout, verbose, onping)

    return nothing
end