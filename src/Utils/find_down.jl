"""
    Look down in the dirtree for files or dirs that make
    'fun' returns true. 'fun' will receive the abspath 
    of each dir or file. All matches will be stored in a 
    container. Use 'retfun' to control when to return 
    the container. 
    Returns all the matches abspath of an empty array
"""
function findall_down(fun::Function, rootdir; container = [], 
        retfun = (container) -> false)

    for (root, dirs, files) in walkdir(rootdir)
        root = abspath(root)

        fun(root) && push!(container, root)

        for file in files
            file = joinpath(root, file)
            fun(file) && push!(container, file)
            retfun(container) && return container
        end
    end
    return container
end
findall_down(suffix::String, rootdir; container = [],
        retfun = (container) -> false) = 
        findall_down((file) -> endswith(file, suffix), rootdir; 
        container = container, retfun = retfun);

"""
    Look down in the dirtree for the first files or dirs 
    that make 'fun' returns true. 'fun' will receive 
    the abspath of each dir or file. 
    Returns an abspath or nothing 
"""
function find_down(fun::Function, rootdir)
    founds = findall_down(fun, rootdir; retfun = (container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
find_down(suffix::String, rootdir) = find_down((file) -> endswith(file, suffix), rootdir);