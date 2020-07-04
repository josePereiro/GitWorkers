# TODO: Add tests
is_copytaskroot(taskroot) = is_taskroot(taskroot) && endswith(abspath(taskroot), COPY_DIR_SUFFIX)

function get_copytask_path(path)
    path = path |> abspath
    ownerroot = find_ownertask(path) |> get_taskroot
    is_copytaskroot(ownerroot) && return path
    return replace(path, ownerroot => ownerroot * COPY_DIR_SUFFIX)
end