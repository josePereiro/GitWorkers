"""
    Create the path of the execution configuration file given a task root
"""
build_task_exec_config_file(taskroot) = joinpath(taskroot, ORIGIN_FOLDER_NAME, TASK_EXEC_CONFIG_FILE_NAME)

"""
Create the path of the execution status file given a task root
"""
build_task_exec_status_file(taskroot) = joinpath(taskroot, LOCAL_FOLDER_NAME, TASK_EXEC_STATUS_FILE_NAME)

