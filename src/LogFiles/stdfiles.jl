build_log_file_path(taskroot, exec_order, suffix) = 
    joinpath(taskroot, LOCAL_FOLDER_NAME, LOGS_FOLDER_NAME, string(exec_order, suffix))
