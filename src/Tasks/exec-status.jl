# TODO: Add tests
build_task_exec_status_file(taskroot) = is_taskroot(taskroot) ? 
    joinpath(taskroot, LOCAL_FOLDER_NAME, TASK_EXEC_STATUS_FILE_NAME) :
    error("$(relpath(taskroot)) not a task dir!!")

"""
    Returns the path to the exec_status_file
    of the path owner task. If path is not a 
    task path throw an error.
"""
function get_task_exec_status_file(path = pwd())
    taskdir = find_ownertask_root(path);
    return build_task_exec_status_file(taskdir)
end