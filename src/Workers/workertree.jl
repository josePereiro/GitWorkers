"""
    This method defines what is a gitworker root in the dir tree
"""
is_workerroot(dir) = isdir(dir) && isfile(joinpath(dir, WORKER_FILE_NAME))

"""
    This method defines what is a gitworker in the dir tree
"""
is_worker(path) = basename(path) == WORKER_FILE_NAME


is_inworker(path = pwd()) = exist_up(is_worker, path)

get_workerroot(workerfile) = is_worker(workerfile) ? workerfile |> dirname :
    error("$(relpath(workerfile)) not a is valid workerfile")