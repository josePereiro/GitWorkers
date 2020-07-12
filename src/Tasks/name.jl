"""
    Returns the name of the task. 
    A repo and a copy task will share the same name
"""
function get_taskname(path = pwd())
    taskfile = find_ownertask(path)
    return relpath_repo(get_repotask_path(taskfile) |> get_taskroot)
end