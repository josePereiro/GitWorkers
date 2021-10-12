function _waitfor_handler(fun::Function; wt = 2.0, tout = 60.0, verb = false)
    val0 = fun()
    t0 = time()
    while true
        # pull and send pushflag
        _repo_update(;verb) do
            _set_pushflag()
            return true
        end
        
        val = fun()
        (val != val0) && return true
        ((time() - t0) > tout) && return false
        sleep(wt)
    end
    return false
end

_waitfor_content_change(path; kwargs...) = _waitfor_handler(; kwargs...) do
    !ispath(path) && return hash(0)
    isfile(path) && return _file_content_hash(path)
    isdir(path) && return hash(_readdir(path))
end
    
_waitfor_size_change(path; kwargs...) = _waitfor_handler(; kwargs...) do
    !ispath(path) && return filesize(path)
    isfile(path) && return filesize(path)
    isdir(path) && _foldersize(path)
end

_waitfor_till_next_iter(; kwargs...) = _waitfor_content_change(_curriter_file(); kwargs...)