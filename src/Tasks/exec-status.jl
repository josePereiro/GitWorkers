# TODO: Add tests
build_task_exec_status_file(taskroot) = is_taskroot(taskroot) ? 
    joinpath(taskroot, LOCAL_FOLDER_NAME, TASK_EXEC_STATUS_FILE_NAME) :
    error("$(relpath(taskroot)) not a task dir!!")

"""
    Returns the path to the exec_status_file
    of the path owner task. If path is not a 
    task path throw an error.
"""
function get_task_exec_status_file(path)
    taskdir = find_ownertask_root(path);
    return build_task_exec_status_file(taskdir)
end

"""
    Return the path owner task exec_status_file content.
    If path is not a task path throw an error.
    If file is missing returns nothing
"""
function read_task_exec_status_toml(path = pwd())
    exec_status_file = get_task_exec_status_file(path)
    return isfile(exec_status_file) ? read_toml(exec_status_file) : nothing
end

# TODO: add comments
function write_task_exec_status_toml(path, exec_status)
    exec_status_file = get_task_exec_status_file(path)
    !isfile(exec_status_file) && create_file(exec_status_file)
    write_toml(exec_status_file, exec_status)
end
write_task_exec_status_toml(exec_status) = 
    write_task_exec_status_toml(pwd(), exec_status)