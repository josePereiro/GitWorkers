
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
    worker = findup_repo(is_worker, path)
    check && isnothing(worker) && error("Not in a `GitWorker` directoty, " *
        "place a '$(WORKER_FILE_NAME)' file in a dir to make one!!!")
    return worker
end

has_ownerworker(path = pwd()) = !isnothing(find_ownerworker(path; check = false))

"""
    Find match in all worker tree
"""
findall_worker(fun::Function, path = pwd()) = findall_down(fun, find_ownerworker(path));
findall_worker(name::AbstractString, path = pwd()) = 
    findall_worker((path) -> basename(path) == name, path);

"""
    Find the first match in the worker tree
"""
findin_worker(fun::Function, path = pwd()) = find_down(fun, find_ownerworker(path));
findin_worker(name::AbstractString, path = pwd()) = 
    findin_worker((path) -> basename(path) == name, path);


"""
    
"""
function findup_worker(fun::Function, path = pwd())
    rootparent = find_ownerworker(path; check = true) |> get_workerroot |> dirname
    founds = findall_up(fun, path; 
        retfun = (path, container) -> length(container) == 1 &&
        path == rootparent
    )
    return isempty(founds) ? nothing : founds |> first
end
findup_worker(name::String, path = pwd()) = 
    findup_worker((path) -> basename(path) == name, path);