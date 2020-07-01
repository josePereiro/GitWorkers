"""
    This function collect, from all the tracked paths, 
    the one that needs to be updated
"""
function get_local_changes()
    tracked_files = get_tracked()
    return filter(tracked_files) do file
        try
            local_file = get_tasklocal(file)
            return mtime(file) < mtime(local_file)
        catch err
            return false
        end
    end
end