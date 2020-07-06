function git_commit(msg, tries = 1, maxwt = 1)
    try
        # TODO: Use LibGit2
        run(Cmd(`git commit -m $msg`))
        log("Changes commited") # TODO: regulate frec
    catch err
        log(err)
        err isa InterruptException && rethrow(err)
        sleep(maxwt * rand())
        tries <= 0 && return false
        git_commit(msg, tries - 1, maxwt)
    end
    return true
end