# TODO: Add tests
build_task_exec_config_file(taskroot) = is_taskroot(taskroot) ? 
    joinpath(taskroot, ORIGIN_FOLDER_NAME, TASK_EXEC_CONFIG_FILE_NAME) :
    error("$(relpath(taskroot)) not a task dir!!")

"""
    Returns the path to the exec_config_file
    of the path owner task. If path is not a 
    task path throw an error.
"""
function get_task_exec_config_file(path = pwd())
    taskdir = find_ownertask_root(path);
    return build_task_exec_config_file(taskdir)
end