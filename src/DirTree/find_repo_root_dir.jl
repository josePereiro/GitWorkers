function find_repo_root_dir(dir = pwd())
    git_dir = look_up(dir, ".git") |> dirname
    isnothing(git_dir) && error("Repo not found, `GitWorker` must be called from withing a git repo")
    return git_dir
end