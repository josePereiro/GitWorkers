"""
    This method will overwrite all repo task origin folders
    with its copy versions. If the local is missing it will be ignored
"""
function copyback_taskorigins()
    taskroots = find_tasks() .|> get_taskroot

    copy_taskroots = filter(is_copytaskroot, taskroots)
    copy_origins = joinpath.(copy_taskroots, ORIGIN_FOLDER_NAME)

    # TODO: use filterfun to avoid copying equal files, or big ones
    for copy_origin in copy_origins
        !isdir(copy_origin) && continue
        repo_origin = get_repotask_path(copy_origin)
        copy_tree(copy_origin, repo_origin; 
            force = true)
    end
end