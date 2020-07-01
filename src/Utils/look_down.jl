# all matches
function look_down_all(fun::Function, rootdir = pwd(); 
        retfun = (container) -> false, 
        ignoreroot::Vector = [joinpath(find_repo_root_dir(rootdir), ".git")]
    )

    container = []
    for (root, dirs, files) in walkdir(rootdir)
        root = root |> abspath

        map((ignored) -> is_subpath(root, ignored), ignoreroot) |> any && continue # skipping
        basename(root) == ".git" && continue
        for file in files
            file = joinpath(root, file)
            fun(file) && push!(container, file)
            retfun(container) && return container
        end
    end
    return container
end
look_down_all(suffix::String, rootdir = pwd(); retfun = (container) -> false) = 
    look_down_all((file) -> endswith(file, suffix), rootdir; retfun = retfun);

# first match
function look_down(fun::Function, rootdir = pwd())
    founds = look_down_all(fun, rootdir; retfun = (container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
look_down(suffix::String, rootdir = pwd()) = look_down((file) -> endswith(file, suffix), rootdir);