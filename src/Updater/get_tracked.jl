#=

    --full-tree: makes the command run as if you were in the repo's root directory.
    -r: recurses into subdirectories. Combined with --full-tree, this gives you all committed, tracked files.
    --name-only: removes SHA / permission info for when you just want the file paths.
    HEAD: specifies which branch you want the list of tracked, committed files for. You could change this to master or any other branch name, but HEAD is the commit you have checked out right now.

=#
"""
    This function collect all existing files being tracked by git
"""
function get_git_tracked() 
    files = read(`git ls-tree --full-tree --name-only -r HEAD`, String) |> split .|> String
    return filter(ispath, joinpath.(REPO_DIR, files))
end
get_git_tracked(dir) = filter((file) -> is_subpath(file, dir), get_git_tracked()) 


"""
    This function collect all files that the user defined to be tracked
    NOTE: it is a priority to keep the repo light
"""
function get_user_tracked()
    # TODO: implement this
    return []
end
function get_user_tracked(dir)
    # TODO: implement this
    return []
end

"""
    Returns all the tracked paths. The paths could not be 
    yet tracked in the repo (Ex: It could be created locally 
    after the last push). 
    All paths are checked to exist
"""
function get_tracked()
    git_tracked = get_git_tracked()
    user_tracked = get_user_tracked()
    tracked = filter(ispath, [git_tracked; user_tracked] |> unique)
end
get_tracked(dir) = filter((file) -> ispath(file) && is_subpath(file, dir), 
    get_tracked()) 