function is_taskorigin(path)
    path = path |> abspath
    owner_task = find_owner_task(path)
    isnothing(owner_task) && return false
    owner_dir = owner_task |> dirname
    return !endswith(owner_dir, LOCAL_DIR_SUFFIX)
end

function get_taskorigin(path) 
    path = path |> abspath
    is_taskorigin(path) && return path
    owner_task = find_owner_task(path)
    isnothing(owner_task) && return nothing
    return replace(path, LOCAL_DIR_SUFFIX => "")
end