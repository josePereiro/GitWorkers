find_taskfiles() = look_down_all(TASK_FILE_NAME, WORKER_DIR)
find_origin_taskfiles() = 
    filter((file) -> is_taskorigin(file), find_taskfiles())
find_local_taskfiles() = 
    filter((file) -> is_tasklocal(file), find_taskfiles())