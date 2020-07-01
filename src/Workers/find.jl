
"""
    Look down for the gitworker files.
    Returns an abspaths array or []. 
"""
find_gitworkerfiles() = findall_down((file) -> basename(file) == WORKER_FILE_NAME, REPO_DIR)

findall_worker(fun::Function) = findall_down(fun, WORKER_DIR);
findall_worker(suffix::AbstractString) = 
    findall_worker((path) -> endswith(path, suffix));

findin_worker(fun::Function) = find_down(fun, WORKER_DIR);
findin_worker(suffix::AbstractString) = 
    findin_worker((path) -> endswith(path, suffix));

"""
    The method look up till find an workerfile
    or throw an error. Returns an abspath
"""
function find_ownerworker(path = pwd())
    !ispath(path) && error("Path $path not found")
    dir = isdir(path) ? path : dirname(path)
    workerfile = find_up(WORKER_FILE_NAME, dir)
    isnothing(workerfile) && error("Not in a `GitWorker` directoty, " *
        "$(WORKER_FILE_NAME) not found!!!")
    return workerfile
end