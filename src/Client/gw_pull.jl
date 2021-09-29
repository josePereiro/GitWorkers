function gw_pull(;force_clonning = false, deb = false)

    _call_sync_script(;
        repodir = _repodir(),
        url = _get_url(),
        pull = true,
        force_clonning,
        push = false,
        success_token = _gen_id(),
        fail_token = _gen_id(),
        ios = deb ? [stdout] : [],
        detach = false
    )
    return nothing
end