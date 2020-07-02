"""
    Look up in the dirtree for files or dirs that make
    'fun' returns true. 'fun' will receive the abspath 
    of each dir or file. All matches will be stored in a 
    container. Use 'retfun' to control when to return 
    the container. 
    Returns all the matches abspath of an empty array
"""
function findall_up(fun::Function, rootpath; container = [], 
        retfun = (container) -> false)
    
    rootpath = rootpath |> abspath
    rootpath = isdir(rootpath) ? rootpath : rootpath |> dirname

    # Match root
    fun(rootpath) && push!(container, rootpath)
    
    # find in root
    for bname in readdir(rootpath)
        path = joinpath(rootpath, bname)
        fun(path) && push!(container, path)
        retfun(container) && return container
    end

    # Base
    rootpath == dirname(rootpath) && return container
    
    # recursive call
    return findall_up(fun, dirname(rootpath); 
        container = container, retfun  = retfun)
end


findall_up(name::AbstractString, rootpath; container = [], 
        retfun = (container) -> false) =
    findall_up((path) -> basename(path) == name, rootpath; 
        container = container, retfun  = retfun)

        
"""
    Look down in the dirtree for the first files or dirs 
    that make 'fun' returns true. 'fun' will receive 
    the abspath of each dir or file. 
    Returns an abspath or nothing 
"""
function find_up(fun::Function, rootpath)
    founds = findall_up(fun, rootpath; retfun = (container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
find_up(name::String, rootpath) = 
    find_up((path) -> basename(path) == name, rootpath);