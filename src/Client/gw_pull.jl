function gw_pull()

    repodir = _repodir()
    url = _get_url()
    success_token = _gen_id()
    fail_token = _gen_id()
    client_ios = [stdout]

    # pull
    _call_sync_script(;
        repodir, url, 
        pull = true,
        force_clonning = false,
        push = false,
        success_token, fail_token,
        ios = client_ios, detach = false
    )
    return nothing
end