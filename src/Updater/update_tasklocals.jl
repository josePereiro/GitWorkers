"""
    This method will overwrite all copy task local folders
    with its repo versions. If the local is missing in the repo 
    it will be created. Any error in copying a file is ignored
"""
function update_tasklocals()

    taskroots = find_tasks() .|> get_taskroot

    copy_taskroots = filter(is_copytaskroot, taskroots)
    copy_locals = joinpath.(copy_taskroots, LOCAL_FOLDER_NAME)

    onerr_ = (src, dest, err) -> nothing
    # TODO: use filterfun to avoid copying equal files, or big ones
    for copy_local in copy_locals
        !isdir(copy_local) && continue
        repo_local = get_repotask_path(copy_local)
        copy_tree(copy_local, repo_local; 
            onerr = onerr_, force = true)
    end
end