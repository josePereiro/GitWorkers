
"""
    Look down for the gitworker files in the repo.
    Returns an abspaths array or []. 
"""
find_gitworkers() = findall_repo(is_worker)

"""
    The method look up till find an workerfile, if check = true
    throw an error if nothing if found. 
    Returns an abspath or nothing
"""
function find_ownerworker(path = pwd(); check = true)
    workerroot = findup_repo(is_workerroot, path)
    check && isnothing(workerroot) && error("Not in a `GitWorker` directoty, " *
        "$(WORKER_FILE_NAME) not found!!!")
    isnothing(workerroot) && return nothing
    return joinpath(workerroot, WORKER_PATTERN)
end

has_ownerworker(path = pwd()) = !isnothing(find_ownerworker(path; check = false))

findall_worker(fun::Function, path = pwd()) = findall_down(fun, find_ownerworker(path));
findall_worker(name::AbstractString, path = pwd()) = 
    findall_worker((path) -> basename(path) == name, path);

findin_worker(fun::Function, path = pwd()) = find_down(fun, find_ownerworker(path));
findin_worker(name::AbstractString, path = pwd()) = 
    findin_worker((path) -> basename(path) == name, path);
