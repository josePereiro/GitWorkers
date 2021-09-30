function _call_nuke_script(;
        repodir, url, depth,
        success_token, fail_token,
        verb = true
    )
    
    # TODO: create script Template to handle custom 'git' commands
    sync_script = joinpath(@__DIR__, "nuke_script.sh")
    cmd = Cmd(String[
        "bash", sync_script, repodir, url, string(depth),
            success_token, fail_token
    ])
    _, out = ExternalCmds.run_cmd(cmd; ios = verb ? [stdout] : [])
    return out
end