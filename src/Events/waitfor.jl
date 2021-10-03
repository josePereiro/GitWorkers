function _waitfor_handler(file, fun; wt = 2.0, tout = 60.0, verb = false)
    val0 = fun(file)
    t0 = time()
    while true
        # pull
        _gw_pull_and_send_pushflag(;verb)
        
        val = fun(file)
        (val != val0) && return true
        ((time() - t0) > tout) && return false
        sleep(wt)
    end
    return false
end

_waitfor_content_change(file; kwargs...) = 
    _waitfor_handler(file, _file_content_hash; kwargs...)
    
_waitfor_size_change(file; kwargs...) = 
    _waitfor_handler(file, filesize; kwargs...)

_waitfor_till_next_iter(; kwargs...) = _waitfor_content_change(_curriter_file(); kwargs...)