"""
    Returns true if the path is the definition of a task
"""
is_task(path) = endswith(abspath(path), TASK_PATTERN)

"""
    Returns true if the dir is a task root
"""
is_taskroot(dir) = isdir(dir) && isfile(joinpath(dir, TASK_PATTERN))

"""
    Given a taskfile returns its root dir
"""
get_taskroot(taskfile) = is_task(taskfile) ? taskfile |> dirname |> dirname :
    error("$(relpath(taskfile)) not a valid taskfile")