"""
    This method will update the existing origin file
    from its local copies. If a local copy is marked to 
    be tracked, and no origin exist, the origin will be created.
"""
function update_origins()

    tracked_files = get_tracked()

    # Task
    # ALL tracked with an existing local will be mirrored to 
    # the origin folder For efficiency, the modification time 
    # and file size will be checked to deside if an existing 
    # couple must be updated
    task_locals = filter(is_tasklocal, tracked_files);
    task_origins = filter(is_taskorigin, tracked_files);
    for path_ in [task_locals; task_origins] |> unique
        !ispath(path_) && continue
        local_ = get_tasklocal(path_)

        !ispath(local_) && continue
        isdir(local_) && continue # TODO: think implementing tracked dirs

        origin_ = get_taskorigin(local_)

        update_ = false
        update_info = ""
        # TODO: export this
        up_frec = 0.1 # Force update with a given frecuency
    
        !ispath(origin_) && 
            (update_ = true; update_info = "Origin missing")
        !update_ && up_frec > rand() &&
            (update_ = true; update_info = "Forced")
        !update_ && filesize(origin_) != filesize(local_) &&
            (update_ = true; update_info = "Diff file size")
        !update_ && mtime(origin_) < mtime(local_) &&
                (update_ = true, update_info = "Newer local")

        if update_

            @show mtime(origin_)

            origin_dir = origin_ |> dirname
            if !isdir(origin_dir)
                mkpath(origin_dir)
                log(origin_dir |> relpath, " created!!!")
            end

            origin_ = cp(local_, origin_, force = true)
            log(origin_ |> relpath, " touched because '$update_info'!!!")
        end
    end

end
