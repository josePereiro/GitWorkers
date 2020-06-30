function find_gitworker_file(dir = pwd())
    repo_dir = find_repo_root_dir(dir)
    worker_file = look_down(WORKER_FILE_NAME, repo_dir)
    isnothing(worker_file) && error("Not in a `GitWorker` repository, " *
        "$(WORKER_FILE_NAME) not found!!!")
    return worker_file
end