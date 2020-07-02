"""
    This method will overwrite all copy task origin folders
    with its repo versions. If the local is missing it will be created
    Any error in copying a file is ignored
"""
function update_taskorigins()
    taskroots = find_tasks() .|> get_taskroot

    local_taskroots = filter(is_repotaskroot, taskroots)
    local_origins = joinpath.(local_taskroots, ORIGIN_FOLDER_NAME)

    oncopy_ = (src, dest) -> println(relpath(src), " => ", relpath(dest))
    onerr_ = (src, dest, err) -> nothing
    # TODO: use filterfun to avoid copying equal files, or big ones
    for local_origin in local_origins
        !isdir(local_origin) && continue
        copy_origin = get_copytask_path(local_origin)
        copy_tree(local_origin, copy_origin; 
            oncopy = oncopy_,
            force = true)
    end
end