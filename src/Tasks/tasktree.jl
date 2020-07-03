"""
    This method defines what is a task root in the dir tree
"""
is_taskroot(dir) = isdir(dir) && isfile(joinpath(dir, ORIGIN_FOLDER_NAME, TASK_FILE_NAME))

"""
    This method defines what is a task in the dir tree
"""
is_task(path) = isfile(path) && basename(dirname(path)) == ORIGIN_FOLDER_NAME && 
    basename(path) == TASK_FILE_NAME


is_intask(path = pwd()) = exist_up(is_task, path)

"""
    Given a taskfile returns its root dir
"""
get_taskroot(taskfile) = is_task(taskfile) ? taskfile |> dirname |> dirname :
    error("$(relpath(taskfile)) not a valid taskfile")