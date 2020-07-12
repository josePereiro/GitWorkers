# Tests at file://./../../test/TreeTests/workertree_tests.jl

build_worker_file(root) = joinpath(root, WORKER_FILE_NAME)

"""
    Given a workerfile, returns the worker root dir path.
    This method do not makes any check to the 
    taskfile
"""
get_workerroot(workerfile) = workerfile |> abspath |> dirname

"""
    This method defines what is a gitworker root in the dir tree
"""
is_workerroot(dir) = dir |> isdir && dir |> build_worker_file |> isfile && dir |> is_inrepo

"""
    This method defines what is a gitworker in the dir tree
"""
is_worker(path) = path |> isfile && path |> get_workerroot |> is_workerroot



function is_inworker(path = pwd(),
        ownerworker = find_ownerworker(path, check = false)) 
    isnothing(ownerworker) && return false
    taskroot = ownerworker |> get_workerroot
    return is_subpath(path, taskroot)
end

relpath_worker(path) = relpath(path, find_ownerworker(path) |> get_workerroot)