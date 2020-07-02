is_worker(path) = endswith(abspath(path), WORKER_PATTERN)
is_workerroot(dir) = isdir(dir) && isfile(joinpath(dir, WORKER_PATTERN))

get_workerroot(workerfile) = is_worker(workerfile) ? workerfile |> dirname :
    error("$(relpath(workerfile)) not a is valid workerfile")