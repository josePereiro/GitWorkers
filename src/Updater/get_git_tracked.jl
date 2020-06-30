#=

    --full-tree: makes the command run as if you were in the repo's root directory.
    -r: recurses into subdirectories. Combined with --full-tree, this gives you all committed, tracked files.
    --name-only: removes SHA / permission info for when you just want the file paths.
    HEAD: specifies which branch you want the list of tracked, committed files for. You could change this to master or any other branch name, but HEAD is the commit you have checked out right now.

=#
# TODO: improve this
get_git_tracked() = read(`git ls-tree --full-tree --name-only -r HEAD`, String) |> split
function get_git_tracked(dir)
    dir = abspath(dir)
    filter(get_git_tracked()) do file
        startswith(abspath(file), dir)
    end
end