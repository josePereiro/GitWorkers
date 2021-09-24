function _repo_update(upfun::Function;
        commit_msg = "Sync at ($(now()))", 
        pull = true,
        push = true,
        force_clonning = false,
        ios = [stdout]
    )

    repodir = _repodir()
    url = _get_url()
    success_token = _gen_id()
    fail_token = _gen_id()

    # TODO: connect to config
    for att in 1:5
        
        # ------------------------------------------------------
        # pull
        _, pull_out = _call_sync_script(;
            repodir, url, 
            pull,
            force_clonning,
            push = false,
            success_token, fail_token,
            ios, detach = false
        )
        !contains(pull_out, success_token) && continue

        # ------------------------------------------------------
        # Should affect repo
        upfun()

        # ------------------------------------------------------
        # pull
        _, push_out = _call_sync_script(;
            commit_msg,
            repodir, url, 
            pull = false,
            force_clonning = false, 
            push,
            success_token, fail_token,
            ios, detach = false
        )
        contains(push_out, success_token) && break

    end

end