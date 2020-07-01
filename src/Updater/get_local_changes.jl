"""
    This function collect, from all the local tracked, 
    the one that needs to be updated
"""
function get_local_changes()
    tracked_files = get_tracked()
    return filter(tracked_files) do file
        try
            local_file = get_tasklocal(file)
            # println(file, ": ", mtime(file))
            # println(local_file, ": ", mtime(local_file))
            return mtime(file) < mtime(local_file)
        catch err
            # println(err)
            return false
        end
    end
end