# function find_gitworker_file(dir = pwd())
#     repo_dir = find_repo_root_dir(dir)
#     worker_file = look_down((file) -> basename(file) == WORKER_FILE_NAME, repo_dir)
#     isnothing(worker_file) && error("Not in a `GitWorker` repository, " *
#         "$(WORKER_FILE_NAME) not found!!!")
#     return worker_file
# end

function find_repodir(dir = pwd())
    git_dir = look_up(".git", dir) |> dirname
    isnothing(git_dir) && error("Repo not found, dir ($dir) must be in a git repo")
    return git_dir
end

find_in_repo