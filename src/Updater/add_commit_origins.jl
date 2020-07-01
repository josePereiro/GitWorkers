"""
    This method will try to add and then commit the current origin
    files
"""
function add_commit_origins(tries = 5)

    tracked_files = get_tracked()

    # Task
    # ALL tracked with an existing origin will be pushed
    task_locals = filter(is_tasklocal, tracked_files);
    task_origins = filter(is_taskorigin, tracked_files);
    for path_ in [task_locals; task_origins] |> unique
        !ispath(path_) && continue
        origin_ = get_taskorigin(path_)

        !add_file(origin_) && return false
    end
    return commit("$WORKER_NAME updated") 
end