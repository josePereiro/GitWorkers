# TODO: Add tests
build_task_exec_config_file(taskroot) = is_taskroot(taskroot) ? 
    joinpath(taskroot, ORIGIN_FOLDER_NAME, TASK_EXEC_CONFIG_FILE_NAME) :
    error("$(relpath(taskroot)) not a task dir!!")

"""
    Returns the path to the exec_config_file
    of the path owner task. If path is not a 
    task path throw an error.
"""
function get_task_exec_config_file(path)
    taskdir = find_ownertask_root(path);
    return build_task_exec_config_file(taskdir)
end

"""
    Return the path owner task exec_config_file content.
    If path is not a task path throw an error.
    If file is missing returns nothing
"""
function read_task_exec_config_toml(path = pwd())
    exec_config_file = get_task_exec_config_file(path)
    return isfile(exec_config_file) ? read_toml(exec_config_file) : nothing
end

# TODO: add comments
function write_task_exec_config_toml(path, exec_config)
    exec_config_file = get_task_exec_config_file(path)
    !isfile(exec_config_file) && create_file(exec_config_file)
    write_toml(exec_config_file, exec_config)
end
write_task_exec_config_toml(exec_config) = 
    write_task_exec_config_toml(pwd(), exec_config)