"""
    Look down in the dirtree for files or dirs that make
    'fun' returns true. 'fun' will receive the abspath 
    of each dir or file. All matches will be stored in a 
    container. Use 'retfun' to control when to return 
    the container. 
    Returns all the matches abspath of an empty array
"""
function findall_down(fun::Function, rootpath; container = [], 
        retfun = (container) -> false)
    rootpath = isdir(rootpath) ? rootpath : rootpath |> dirname

    fun(rootpath) && push!(container, rootpath)

    for (root, dirs, files) in walkdir(rootpath)
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
findall_down(name::AbstractString, rootpath; container = [],
        retfun = (container) -> false) = 
        findall_down((path) -> basename(path) == name, rootpath; 
        container = container, retfun = retfun);

"""
    Look down in the dirtree for the first files or dirs 
    that make 'fun' returns true. 'fun' will receive 
    the abspath of each dir or file. 
    Returns an abspath or nothing 
"""
function find_down(fun::Function, rootpath)
    founds = findall_down(fun, rootpath; retfun = (container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
find_down(name::AbstractString, rootpath) = find_down((path) -> basename(path) == name, rootpath);