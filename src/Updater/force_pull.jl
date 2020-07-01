"""
    This method will fetch and hard reset to make a forced pull
    of the origin. It will intented a number (tries) of times
    before returning.
    Return true if no error was raised
"""
function force_pull(tries = 5, maxwt = 5)
    
    try
        # TODO: Use LibGit2
        run(`git fetch`)
        run(`git reset --hard FETCH_HEAD`)
        log("Local repo updated") # TODO: regulate frec
    catch err
        log(err)
        err isa InterruptException && rethrow(err)
        sleep(maxwt * rand())
        tries <= 0 && return false
        force_pull(tries - 1, maxwt)
    end
    return true
end