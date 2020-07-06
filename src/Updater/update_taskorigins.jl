"""
    This method will overwrite all copy task origin folders
    with its repo versions. If the local is missing it will be created
    Any error in copying a file is ignored
"""
function update_taskorigins()
    taskroots = find_tasks() .|> get_taskroot

    repo_taskroots = filter(is_repotaskroot, taskroots)
    repo_origins = joinpath.(repo_taskroots, ORIGIN_FOLDER_NAME)

    # TODO: use filterfun to avoid copying equal files, or big ones
    for repo_origin in repo_origins
        !isdir(repo_origin) && continue
        copy_origin = get_copytask_path(repo_origin)
        copy_tree(repo_origin, copy_origin; 
            force = true)
    end

end