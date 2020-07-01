"""
    Look up in the dirtree for files or dirs that make
    'fun' returns true. 'fun' will receive the abspath 
    of each dir or file. All matches will be stored in a 
    container. Use 'retfun' to control when to return 
    the container. 
    Returns all the matches abspath of an empty array
"""
function findall_up(fun::Function, rootdir; container = [], 
        retfun = (container) -> false)
        
    rootdir = rootdir |> abspath
    
    # find in root
    for bname in readdir(rootdir)
        path = joinpath(rootdir, bname)
        fun(path) && push!(container, path)
        retfun(container) && return container
    end

    # Base
    rootdir == dirname(rootdir) && return container
    
    # recursive call
    return findall_up(fun, dirname(rootdir); 
        container = container, retfun  = retfun)
end


findall_up(suffix::AbstractString, rootdir; container = [], 
        retfun = (container) -> false) =
    findall_up((path) -> endswith(path, suffix), rootdir; 
        container = container, retfun  = retfun)

        
"""
    Look down in the dirtree for the first files or dirs 
    that make 'fun' returns true. 'fun' will receive 
    the abspath of each dir or file. 
    Returns an abspath or nothing 
"""
function find_up(fun::Function, rootdir)
    founds = findall_up(fun, rootdir; retfun = (container) -> length(container) == 1)
    return isempty(founds) ? nothing : founds |> first
end
find_up(suffix::String, rootdir) = find_up((file) -> endswith(file, suffix), rootdir);