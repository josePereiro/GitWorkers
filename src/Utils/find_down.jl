"""
    Look down in the dirtree for files or dirs that make
    'fun' returns true. All matches will be stored in a 
    container. Use 'retfun' to control when to return 
    the container.Also use 'onerr' to manage possibles 
    errors.
    Returns all the matches abspath of an empty array
    Signature:
        fun(path)::Bool
        retfun(path, container)::Bool
        onerr(path, container, err)::Bool
"""
function findall_down(fun::Function, rootpath; container = [], 
        retfun = (path, container) -> false,
        onerr = (path, container, err) -> false)
    rootpath = isdir(rootpath) ? rootpath : rootpath |> dirname

    try
        fun(rootpath) && push!(container, rootpath)
        retfun(rootpath, container) && return container
    catch err
        onerr(rootpath, container, err) && return container
    end

    for (root, dirs, files) in walkdir(rootpath)
        root = abspath(root)

        try
            fun(root) && push!(container, root)
            retfun(root, container) && return container
        catch err
            onerr(rootpath, container, err) && return container
        end

        for file in files
            file = joinpath(root, file)
            try
                fun(file) && push!(container, file)
                retfun(file, container) && return container
            catch err
                onerr(rootpath, container, err) && return container
            end
        end
    end
    return container
end
findall_down(name::AbstractString, rootpath; kwargs...) = 
        findall_down((path) -> basename(path) == name, rootpath; kwargs...);

"""
    Look down in the dirtree for the first files or dirs 
    that make 'fun' returns true. 'fun' will receive 
    the abspath of each dir or file. 
    Returns an abspath or nothing 
"""
function find_down(fun::Function, rootpath)
    founds = findall_down(fun, rootpath; retfun = (path, container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
find_down(name::AbstractString, rootpath) = find_down((path) -> basename(path) == name, rootpath);