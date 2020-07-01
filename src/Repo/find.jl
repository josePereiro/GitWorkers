"""
    Look up for a .git dir. Return the parent dir absolute path.
    Or throw an error. 
"""
function find_rootdir(dir = pwd())
    git_dir = find_up(".git", dir) |> dirname
    isnothing(git_dir) && error("Repo not found, dir ($dir) must be in a git repo")
    return git_dir
end

findall_repo(fun::Function) = findall_down(fun, REPO_DIR);
findall_repo(suffix::AbstractString) = 
    findall_repo((path) -> endswith(path, suffix));

findin_repo(fun::Function) = find_down(fun, REPO_DIR);
findin_repo(suffix::AbstractString) = 
    findin_repo((path) -> endswith(path, suffix));


"""
    Look down for the first gitworker file.
    Returns an abspath or throw an error. 
"""
function find_gitworkerfile(dir = find_rootdir())
    repo_dir = find_rootdir(dir)
    worker_file = find_down((file) -> basename(file) == WORKER_FILE_NAME, repo_dir)
    isnothing(worker_file) && error("Not in a `GitWorker` repository, " *
        "$(WORKER_FILE_NAME) not found!!!")
    return worker_file
end

findall_worker(fun::Function) = findall_down(fun, WORKER_DIR);
findall_worker(suffix::AbstractString) = 
    findall_worker((path) -> endswith(path, suffix));

findin_worker(fun::Function) = find_down(fun, WORKER_DIR);
findin_worker(suffix::AbstractString) = 
    findin_worker((path) -> endswith(path, suffix));
