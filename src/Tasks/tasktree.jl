
"""
    This method defines what is a task root in the dir tree
"""
is_taskroot(dir) = isdir(dir) && isfile(joinpath(dir, ORIGIN_FOLDER_NAME, TASK_FILE_NAME))

"""
    This method defines what is a task in the dir tree
"""
is_task(path) = isfile(path) && basename(dirname(path)) == ORIGIN_FOLDER_NAME && 
    basename(path) == TASK_FILE_NAME

"""
    Given a taskfile, returns the task root dir path.
    This method do not makes any check to the 
    taskfile
"""
get_taskroot(taskfile) = taskfile |> abspath |> dirname |> dirname

function is_intask(path = pwd(), 
        ownertask = find_ownertask(path, check = false)) 
    isnothing(ownertask) && return false
    taskroot = ownertask |> get_taskroot
    return is_subpath(path, taskroot)
end

