"""
    Create the path of the execution configuration file given a task root
"""
build_task_exec_config_file(taskroot) = joinpath(taskroot, ORIGIN_FOLDER_NAME, TASK_EXEC_CONFIG_FILE_NAME)

"""
Create the path of the execution status file given a task root
"""
build_task_exec_status_file(taskroot) = joinpath(taskroot, LOCAL_FOLDER_NAME, TASK_EXEC_STATUS_FILE_NAME)


function read_task_exec_config(task, key; check_type = true)
    exec_config_file = build_task_exec_config_file(task |> get_taskroot)
    return read_control(exec_config_file, key; check_type = check_type)
end

function write_task_exec_config(task, key, val; check_type = true)
    exec_config_file = build_task_exec_config_file(task |> get_taskroot)
    return write_control(exec_config_file, key, val; check_type = check_type)
end

function read_task_exec_status(task, key; check_type = true)
    exec_status_file = build_task_exec_status_file(task |> get_taskroot)
    return read_control(exec_status_file, key; check_type = check_type)
end

function write_task_exec_status(task, key, val; check_type = true)
    exec_status_file = build_task_exec_status_file(task |> get_taskroot)
    return write_control(exec_status_file, key, val; check_type = check_type)
end

