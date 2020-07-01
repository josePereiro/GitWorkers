"""
    Returns the task (taskfile) that contains the 
    given path, or nothing otherwise.
    If the path does not exis raise an error
"""
function find_owner_task(path = pwd())
    path = path |> abspath
    !ispath(path) && error("Path $path not found!!!")
    dir = isdir(path) ? path : dirname(path)
    return look_up(TASK_FILE_NAME, dir) 
end