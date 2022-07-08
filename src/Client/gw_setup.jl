function gw_setup(;
        sys_root = homedir(),
        remote_url::String
    )

    # init
    gw = GitWorker(remote_url, sys_root; write = true)
    gw_curr!(gw)

    return nothing
end

gw_setup(gw::GitWorker) = 
    gw_setup(; sys_root = sys_root(gw), remote_url = remote_url(gw))