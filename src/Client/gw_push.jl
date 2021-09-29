function gw_push(; deb = false)

    _call_sync_script(;
        repodir = _repodir(),
        url = _get_url(),
        pull = false,
        force_clonning = false,
        push = true,
        success_token = _gen_id(),
        fail_token = _gen_id(),
        ios = deb ? [stdout] : [],
        detach = false
    )
    return nothing
end