function _gw_pull(;
        repodir = _repodir(),
        url = _get_url(),
        success_token = _gen_id(),
        fail_token = _gen_id(),
        clonning_token = _gen_id(),
        force_clonning = false,
        verb = true, 
        feedback::Function = (out) -> nothing
    )
    
    verb && println("_gw_pull")
    out = _call_sync_script(;
        repodir, url, 
        pull = true,
        force_clonning,
        push = false,
        success_token, fail_token, clonning_token,
        verb
    )
    feedback(out)
    return contains(out, success_token)

end

function _gw_push(;
        commit_msg = "Sync at ($(now()))", 
        repodir = _repodir(),
        url = _get_url(),
        success_token = _gen_id(),
        fail_token = _gen_id(),
        clonning_token = _gen_id(),
        feedback::Function = (out) -> nothing,
        verb = true
    )

    verb && println("_gw_push")
    out = _call_sync_script(;
        commit_msg,
        repodir, url, 
        pull = false,
        force_clonning = false,
        push = true,
        success_token, fail_token, clonning_token,
        verb
    )
    feedback(out)
    return contains(out, success_token)

end

function _repo_update(upfun::Function;
        commit_msg = "Update at ($(now()))", 
        force_clonning = false,
        clear_wdir = true,
        verb = false
    )
    
    verb && println("_repo_update")
    success = false

    # ------------------------------------------------------
    # sys maintinance
    clear_wdir && _clear_repowdir()

    # TODO: connect to config
    for att in 1:5

        # ------------------------------------------------------
        # pull
        success = _gw_pull(; force_clonning, verb)
        !success && continue

        # ------------------------------------------------------
        # Should affect repo
        pushflag = upfun()

        # ------------------------------------------------------
        # push
        if pushflag === true
            success = _gw_push(; commit_msg, verb)
            success && break
        end

    end

    return success

end
