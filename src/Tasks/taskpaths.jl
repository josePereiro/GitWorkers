function is_taskpath(path = pwd())
    path = path |> abspath
    !ispath(path) && error("Path $path not found!!!")
    owner_task = find_owner_task(path)
    return !isnothing(owner_task)
end