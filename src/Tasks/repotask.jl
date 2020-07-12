# TODO: Add tests
is_repotaskroot(taskroot) = is_taskroot(taskroot) && !endswith(abspath(taskroot), GITWORKER_COPY_SUFIX)

function get_repotask_path(path)
    path = path |> abspath
    ownerroot = find_ownertask(path) |> get_taskroot
    is_repotaskroot(ownerroot) && return path
    return replace(path, ownerroot => replace(ownerroot, GITWORKER_COPY_SUFIX => ""))
end