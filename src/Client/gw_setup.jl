function gw_setup(;
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        url::String,
        verbose = false, 
    )

    # init
    gw = GitWorker(;sys_root, remote_url = url)
    gl = gitlink(gw)

    # init gitlink
    init_ok = GitLinks.instantiate(gl; verbose)
    if init_ok
        @info("Worker connected", url)
    else
        error("GitLink init fail (run 'git ls-remote <remote_url>' for testing connection)\nremote_url:$(url)")
    end
    
    gw_curr(gw)

    return gw
end

gw_setup(gw::GitWorker; verbose = false) = 
    gw_setup(; verbose, sys_root = sys_root(gw), url = remote_url(gw))