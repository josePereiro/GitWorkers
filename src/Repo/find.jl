"""
    Look up for a .git dir. Return the parent dir absolute path.
    Or throw an error. 
"""
function find_rootdir(dir = pwd())
    git_dir = find_up(".git", dir) |> dirname
    isnothing(git_dir) && error("Repo not found, dir ($dir) must be in a git repo")
    return git_dir
end

findall_repo(fun::Function) = findall_down(fun, REPO_DIR);
findall_repo(suffix::AbstractString) = 
    findall_repo((path) -> endswith(path, suffix));

findin_repo(fun::Function) = find_down(fun, REPO_DIR);
findin_repo(suffix::AbstractString) = 
    findin_repo((path) -> endswith(path, suffix));