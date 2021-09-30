function gw_ping(;tout = 60.0, verb = false)

    t0 = time()
    
    # wait
    try
        _waitfor_till_next_iter(;tout, verb)
        remote = _get_url()
        msg = string("Ping in ", round(time() - t0; sigdigits = 3), " secund(s)")
        curriter = _get_curriter()
        @info(msg, remote, curriter)
        gw_ping(;tout, verb)
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end