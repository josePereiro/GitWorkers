"""
    This method will try to push the current origins
    It is important ensure that the worker repo is pushable
"""
function git_push(;force = false)
    try
        # TODO: Use LibGit2
        force ? run(`git push --force`) : run(`git push`)
        log("repo pushed") # TODO: regulate frec
    catch err
        log(err)
        err isa InterruptException && rethrow(err)
    end
    return true
end