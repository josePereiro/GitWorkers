"""
    Returns true if the given path is 
    inside a local copy of a task.
    If the path does not exis raise an error
"""
function is_tasklocal(path)
    path = path |> abspath
    owner_task = find_owner_task(path)
    isnothing(owner_task) && return false
    owner_dir = owner_task |> dirname
    return endswith(owner_dir, LOCAL_DIR_SUFFIX)
end

"""
    If the given path is contained in a task, 
    returns it equvalent in the local task tree.
    If the path does not exis raise an error
"""
function get_tasklocal(path) 
    path = path |> abspath
    is_tasklocal(path) && return path
    owner_task = find_owner_task(path)
    isnothing(owner_task) && return nothing
    owner_dir = owner_task |> dirname
    local_dir = owner_dir * LOCAL_DIR_SUFFIX
    return replace(path, owner_dir => local_dir)
end