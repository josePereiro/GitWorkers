# all matches
function look_down_all(fun::Function, rootdir = pwd(); retfun = (container) -> false)
    container = []
    for (root, dirs, files) in walkdir(rootdir)
        root = abspath(root)
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
look_down(fun::Function, rootdir = pwd()) = look_down_all(fun, rootdir; 
    retfun = (container) -> length(container) == 1) |> first
look_down(suffix::String, rootdir = pwd()) = look_down((file) -> endswith(file, suffix), rootdir);