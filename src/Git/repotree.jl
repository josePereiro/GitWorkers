
"""
This method defines what is a git repo root in the tree
"""
is_reporoot(path) = isdir(path) && isdir(joinpath(path, GIT_DIR_NAME))

"""
    This method defines what is a git repo in the dir tree
"""
is_repo(path) = path |> dirname |> is_reporoot

is_inrepo(path = pwd()) = exist_up(is_repo, path)