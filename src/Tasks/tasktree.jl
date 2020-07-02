is_task(path) = endswith(abspath(path), TASK_PATTERN)
is_taskroot(dir) = isdir(dir) && isfile(joinpath(dir, TASK_PATTERN))

get_taskroot(taskfile) = is_task(taskfile) ? taskfile |> dirname |> dirname :
    error("$(relpath(taskfile)) not a is valid taskfile")