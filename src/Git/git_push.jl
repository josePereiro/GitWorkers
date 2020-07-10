"""
    This method will try to push the current origins
    It is important ensure that the worker repo is pushable
"""
function git_push(;force = false, print = true)
    # TODO: Use LibGit2
    cmd = force ? `git push --force` : `git push`
    wait(run(cmd, wait = print))
end