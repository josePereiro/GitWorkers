function _gw_pull(;
        repodir = _repodir(),
        url = _get_url(),
        success_token = _gen_id(),
        fail_token = _gen_id(),
        force_clonning = false,
        ios = [stdout]
    )
    
    _, out = _call_sync_script(;
        repodir, url, 
        pull = true,
        force_clonning,
        push = false,
        success_token, fail_token,
        ios, detach = false
    )
    return contains(out, success_token)

end

function _gw_push(;
        commit_msg = "Sync at ($(now()))", 
        repodir = _repodir(),
        url = _get_url(),
        success_token = _gen_id(),
        fail_token = _gen_id(),
        ios = [stdout]
    )

    _, out = _call_sync_script(;
        commit_msg,
        repodir, url, 
        pull = false,
        force_clonning = false,
        push = true,
        success_token, fail_token,
        ios, detach = false
    )
    return contains(out, success_token)

end

function _repo_update(upfun::Function;
        commit_msg = "Update at ($(now()))", 
        force_clonning = false,
        deb = false
    )
    
    ios = deb ? [stdout] : []
    success = false

    # TODO: connect to config
    for att in 1:5
        
        # ------------------------------------------------------
        # pull
        success = _gw_pull(; force_clonning, ios)
        !success && continue

        # ------------------------------------------------------
        # Should affect repo
        upflag = upfun()

        # ------------------------------------------------------
        # pull
        if upflag === true
            success = _gw_push(;commit_msg, ios)
            success && break
        end

    end

    return success

end
