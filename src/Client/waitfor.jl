function _waitfor_content_change(file; wt = 1.0, tout = 60.0)
    
    hash0 = _file_content_hash(file)
    t0 = time()

    while true
        # pull
        gw_pull(;ios = [])

        hash_ = _file_content_hash(file)
        (hash_ != hash0) && return
        ((time() - t0) > tout) && error("No response, time out: ", tout)
        sleep(wt)
    end
end

function _waitfor_size_change(file; wt = 1.0, tout = 60.0)
    
    size0 = filesize(file)
    t0 = time()

    while true
        # pull
        gw_pull(;ios = [])

        size_ = filesize(file)
        (size_ != size0) && return
        ((time() - t0) > tout) && error("No response, time out: ", tout)
        sleep(wt)
    end
end

_waitfor_till_next_iter(; kwargs...) = _waitfor_content_change(_curriter_sysfile(); kwargs...)