# TODO: Use LibGit2
git_commit(msg; print = true) = !isempty(git_staged()) && wait(run(`git commit -m $msg`, wait = print))