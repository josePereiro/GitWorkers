# TODO: Use LibGit2
git_add_all(;print = true) = wait(run(`git add --all`, wait = print))