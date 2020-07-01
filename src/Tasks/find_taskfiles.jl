"""
    Look for all the tree from WORKER_DIR for files
    such basename(file) == TASK_FILE_NAME
"""
find_taskfiles() = look_down_all((file) -> basename(file) == TASK_FILE_NAME, WORKER_DIR)
find_origin_taskfiles() = 
    filter((file) -> is_taskorigin(file), find_taskfiles())
find_local_taskfiles() = 
    filter((file) -> is_tasklocal(file), find_taskfiles())