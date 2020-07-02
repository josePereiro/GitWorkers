function git_add_all(tries = 5, maxwt = 1)
    try
        # TODO: Use LibGit2
        run(Cmd(`git add --all`))
        log("Files added") # TODO: regulate frec
    catch err
        log(err)
        err isa InterruptException && rethrow(err)
        sleep(maxwt * rand())
        tries <= 0 && return false
        git_add_all(tries - 1, maxwt)
    end
    return true
end