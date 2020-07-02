is_repotaskroot(taskroot) = is_taskroot(taskroot) && !endswith(abspath(taskroot), COPY_DIR_SUFFIX)

function get_repotask_path(path)
    path = path |> abspath
    ownerroot = find_ownertask(path) |> get_taskroot
    is_repotaskroot(ownerroot) && return path
    return replace(path, ownerroot => replace(ownerroot, COPY_DIR_SUFFIX => ""))
end