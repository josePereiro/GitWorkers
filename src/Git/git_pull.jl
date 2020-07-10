"""
    This method pull from origin, if force = true make
    'git fetch' and `git reset --hard FETCH_HEAD` to make local 
    identical to origin.
    Otherwise do just 'git pull'.
    If print = true, the git answer will be outputed
"""
function git_pull(;force = false, print = true)
    # TODO: Use LibGit2
    if force
        wait(run(`git fetch`, wait = print))
        wait(run(`git reset --hard FETCH_HEAD`, wait = print))
    else
        wait(run(`git pull`, wait = print))
    end
end