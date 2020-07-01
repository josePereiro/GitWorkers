function look_up(fun::Function, rootdir = pwd(), last_rootdir = nothing)
    rootdir = rootdir |> abspath
    
    # find in root
    for bname in readdir(rootdir)
        fun(bname) && return joinpath(rootdir, bname)
    end
    
    # Base
    rootdir == last_rootdir && return nothing
    
    # recursive call
    return look_up(fun, dirname(rootdir), rootdir)
end
look_up(suffix::AbstractString, rootdir = pwd(), last_rootdir = nothing) =
    look_up((bname) -> endswith(bname, suffix), rootdir, last_rootdir)
