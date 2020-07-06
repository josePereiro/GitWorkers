"""
    This method will try to push the current origins
    It is important ensure that the worker repo is pushable
"""
function git_push(tries = 1, maxwt = 5)
    try
        # TODO: Use LibGit2
        run(`git push`)
        log("repo pushed") # TODO: regulate frec
    catch err
        log(err)
        err isa InterruptException && rethrow(err)
        sleep(maxwt * rand())
        tries <= 0 && return false
        git_push(tries - 1, maxwt)
    end
    return true
end