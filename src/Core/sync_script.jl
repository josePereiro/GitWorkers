## ---------------------------------------------------------------
# control sync_script
_SYNC_SCRIPT_PULL_OR_CLONE_MODE = "PULL_OR_CLONE"
_SYNC_SCRIPT_PULL_OR_CLONE_AND_PUSH_MODE = "PULL_OR_CLONE_AND_PUSH"
_SYNC_SCRIPT_FORCE_CLONE_MODE = "FORCE_CLONE"
_SYNC_SCRIPT_FORCE_CLONE_AND_PUSH_MODE = "FORCE_CLONE_AND_PUSH"
_SYNC_SCRIPT_PUSH_MODE = "PUSH"

## ---------------------------------------------------------------
function _call_sync_script(sync_script, repodir, url, op_mode, commit_msg, success_token, fail_token; 
        ios = [stdout], detach = false
    )
    cmd = Cmd(["bash", sync_script, repodir, url, op_mode, commit_msg, success_token, fail_token])
    _run(cmd; ios, detach)
end