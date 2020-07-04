"""
    This method defines what is a gitworker root in the dir tree
"""
is_workerroot(dir) = is_inrepo(dir) && isdir(dir) && isfile(joinpath(dir, WORKER_FILE_NAME))

"""
    This method defines what is a gitworker in the dir tree
"""
is_worker(path) = is_inrepo(path) && basename(path) == WORKER_FILE_NAME


function is_inworker(path = pwd(),
        ownerworker = find_ownerworker(path, check = false)) 
    isnothing(ownerworker) && return false
    taskroot = ownerworker |> get_workerroot
    return is_subpath(path, taskroot)
end

"""
    Given a workerfile, returns the worker root dir path.
    This method do not makes any check to the 
    taskfile
"""
get_workerroot(workerfile) = workerfile |> abspath |> dirname