function get_log_file(path, exec_order, suffix)
    task = find_ownertask(path)
    taskroot = task |> get_taskroot
    return build_log_file_path(taskroot, exec_order, suffix)
end

get_stdout_file(path, exec_order; allow_missing = false) = 
    get_log_file(path, exec_order, STDOUT_LOG_FILE_SUFFIX)

get_stderr_file(path, exec_order; allow_missing = false) = 
    get_log_file(path , exec_order, STDERR_LOG_FILE_SUFFIX)