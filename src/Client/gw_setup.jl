function gw_setup(remote_url::String;
        verbose = false, 
        sys_root = _GW_SYSTEM_DFLT_ROOT
    )

    # init
    gw = GitWorker(;sys_root, remote_url)
    gl = gitlink(gw)

    # init gitlink
    init_ok = GitLinks.instantiate(gl; verbose)
    if init_ok
        @info("Worker connected", remote_url)
    else
        error("GitLink init fail (run 'git ls-remote <remote_url>' for testing connection)", remote_url)
    end

    gw_curr(gw)

    return gw
end

gw_setup(gw::GitWorker; verbose = false) = 
    gw_setup(remote_url(gw); verbose, sys_root = sys_root(gw))