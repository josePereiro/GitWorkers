"""
    This method will overwrite all copy task origin folders
    with its repo versions. If the local is missing it will be created
    Any error in copying a file is ignored
"""
function sync_taskdirs(src, dir; onerr_ = (src, dest, err) -> nothing)
    taskroots = find_tasks() .|> get_taskroot

    if src == REPO_ID
        # repo -> copy
        repo_taskroots = filter(is_repotaskroot, taskroots)
        repo_origins = joinpath.(repo_taskroots, dir)

        # TODO: use filterfun to avoid copying equal files, or big ones
        for repo_origin in repo_origins
            !isdir(repo_origin) && continue
            copy_origin = get_copytask_path(repo_origin)
            copy_tree(repo_origin, copy_origin; 
                onerr = onerr_, force = true)
        end

    elseif src == COPY_ID
        # copy -> repo
        copy_taskroots = filter(is_copytaskroot, taskroots)
        copy_origins = joinpath.(copy_taskroots, dir)

        # TODO: use filterfun to avoid copying equal files, or big ones
        for copy_origin in copy_origins
            !isdir(copy_origin) && continue
            repo_origin = get_repotask_path(copy_origin)
            copy_tree(copy_origin, repo_origin; 
                onerr = onerr_, force = true)
        end

    else
        error("src must be either $REPO_ID or $COPY_ID")
    end

end