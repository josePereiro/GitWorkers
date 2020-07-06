function git_commit(msg)
    isempty(git_staged()) && return false # No changes to commit
    try
        # TODO: Use LibGit2
        run(Cmd(`git commit -m $msg`, ignorestatus = true))
        log("Changes commited") # TODO: regulate frec
        return true
    catch err
        return false
    end
end