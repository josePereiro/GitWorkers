"""
    Look up in the dirtree for files or dirs that make
    'fun' returns true. All matches will be stored in a 
    container. Use 'retfun' to control when to return 
    the container. Also use 'onerr' to manage possibles 
    errors.
    Returns all the matches abspath of an empty array
    Signature:
        fun(path)::Bool
        retfun(path, container)::Bool
        onerr(path, container, err)::Bool
"""
function findall_up(fun::Function, rootpath; container = [], 
        retfun = (path, container) -> false,
        onerr = (path, container, err) -> false)
    
    rootpath = rootpath |> abspath
    rootpath = isdir(rootpath) ? rootpath : rootpath |> dirname

    # Match root
    fun(rootpath) && push!(container, rootpath)
    
    # find in root
    for bname in readdir(rootpath)
        path = joinpath(rootpath, bname)
        try
            fun(path) && push!(container, path)
            retfun(path, container) && return container
        catch err
            onerr(path, container, err) && return container
        end
    end

    # Base
    rootpath == dirname(rootpath) && return container
    
    # recursive call
    return findall_up(fun, dirname(rootpath); 
        container = container, retfun  = retfun)
end


findall_up(name::AbstractString, rootpath; kwargs...) =
    findall_up((path) -> basename(path) == name, rootpath; kwargs...)

        
"""
    Look down in the dirtree for the first files or dirs 
    that make 'fun' returns true. 'fun' will receive 
    the abspath of each dir or file. 
    Returns an abspath or nothing 
"""
function find_up(fun::Function, rootpath)
    founds = findall_up(fun, rootpath; 
        retfun = (path, container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
find_up(name::String, rootpath) = 
    find_up((path) -> basename(path) == name, rootpath; kwargs...);