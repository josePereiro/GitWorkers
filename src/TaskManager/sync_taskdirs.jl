"""
    This method will overwrite all copy task origin folders
    with its repo versions. If the local is missing it will be created
    Any error in copying a file is ignored
"""
function sync_taskdirs(from, dir, path = pwd(); onerr_ = (from, dest, err) -> nothing)
    taskroots = findtasks_worker(path) .|> get_taskroot

    if from == FROM_REPO
        # repo -> copy
        repo_taskroots = filter(is_repotaskroot, taskroots)
        repo_dirs = joinpath.(repo_taskroots, dir)

        # TODO: use filterfun to avoid copying equal files, or big ones
        for repo_dir in repo_dirs
            !isdir(repo_dir) && continue
            copy_dir = get_copytask_path(repo_dir)
            copy_tree(repo_dir, copy_dir; 
                onerr = onerr_, force = true)
        end

    elseif from == FROM_COPY
        # copy -> repo
        copy_taskroots = filter(is_copytaskroot, taskroots)
        copy_dirs = joinpath.(copy_taskroots, dir)

        # TODO: use filterfun to avoid copying equal files, or big ones
        for copy_dir in copy_dirs
            !isdir(copy_dir) && continue
            repo_dir = get_repotask_path(copy_dir)
            copy_tree(copy_dir, repo_dir; 
                onerr = onerr_, force = true)
        end

    else
        error("from must be either $FROM_REPO or $FROM_COPY")
    end

end