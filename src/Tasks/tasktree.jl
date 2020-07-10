# Tests at file://./../../test/TreeTests/tasktree_tests.jl
"""
    This method defines what is a task root in the dir tree
"""
is_taskroot(dir) = is_inrepo(dir) && isdir(dir) && isfile(build_task_file(dir))

"""
    This method defines what is a task in the dir tree
"""
is_task(path) = is_inrepo(path) && isfile(path) && basename(dirname(path)) == ORIGIN_FOLDER_NAME && 
    basename(path) == TASK_FILE_NAME

build_task_file(taskroot) = joinpath(taskroot, ORIGIN_FOLDER_NAME, TASK_FILE_NAME)

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


relpath_task(path) = relpath(path, find_ownertask(path) |> get_taskroot)