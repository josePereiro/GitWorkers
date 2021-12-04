function gw_setup(;
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        url::String
    )

    # init
    gw = _setup_worker(; sys_root, url)
    gw_curr(gw)
    return nothing
end

gw_setup(gw::GitWorker; verbose = false) = 
    gw_setup(; verbose, sys_root = sys_root(gw), url = remote_url(gw))