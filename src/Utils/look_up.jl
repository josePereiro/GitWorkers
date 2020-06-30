function look_up(rootdir, name, last_rootdir = nothing)
    rootdir = abspath(rootdir)
    
    # find in root
    for file_or_dir in readdir(rootdir)
        basename(file_or_dir) == name && return joinpath(rootdir, file_or_dir)
    end
    
    # Base
    rootdir == last_rootdir && return nothing
    
    # recursive call
    return look_up(dirname(rootdir), name, rootdir)
end