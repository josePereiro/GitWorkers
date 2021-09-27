function gw_pull(;force_clonning = false, ios = [stdout])

    repodir = _repodir()
    url = _get_url()
    success_token = _gen_id()
    fail_token = _gen_id()

    # pull
    _call_sync_script(;
        repodir, url, 
        pull = true,
        force_clonning,
        push = false,
        success_token, fail_token,
        ios, detach = false
    )
    return nothing
end