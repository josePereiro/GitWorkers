
"""
Look down for the gitworker files.
Returns an abspaths array or []. 
"""
find_gitworkers() = findall_repo(is_worker)

"""
    The method look up till find an workerfile, if unsafe = false
    throw an error if nothing if found. 
    Returns an abspath or nothing
"""
function find_ownerworker(path = pwd(); unsafe = false)
    !ispath(path) && error("Path $(relpath(path)) not found")
    dir = isdir(path) ? path : dirname(path)
    workerroot = find_up(is_workerroot, dir)
    !unsafe && isnothing(workerroot) && error("Not in a `GitWorker` directoty, " *
        "$(WORKER_FILE_NAME) not found!!!")
    return joinpath(workerroot, WORKER_PATTERN)
end

has_ownerworker(path = pwd()) = !isnothing(find_ownerworker(path; unsafe = true))

findall_worker(fun::Function, path = pwd()) = findall_down(fun, find_ownerworker(path));
findall_worker(name::AbstractString) = 
    findall_worker((path) -> basename(path) == name);

findin_worker(fun::Function, path = pwd()) = find_down(fun, find_ownerworker(path));
findin_worker(name::AbstractString) = 
    findin_worker((path) -> basename(path) == name);


function find_ownercopy_dir(path; unsafe = false)
    owner = find_ownerworker(path; unsafe = unsafe)
    isnothing(owner) && return nothing
    ownerdir = owner |> dirname
    copydir = is_workercopy_dir(ownerdir) ? ownerdir : 
        build_workercopy_dir(ownerdir)
    return find_ownerworker(copydir; unsafe = unsafe)
end