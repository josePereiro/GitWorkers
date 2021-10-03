function gw_ping(n = 10; tout = 60.0, verb = false)
    (n < 0) && return
    t0 = time()
    
    # wait
    try
        timeout = !_waitfor_till_next_iter(;tout, verb)
        timeout && return
        
        remote = _get_url()
        msg = string("Ping in ", round(time() - t0; sigdigits = 3), " secund(s)")
        curriter = _get_curriter()
        @info(msg, remote, curriter, ping = n)
        gw_ping(n - 1;tout, verb)
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end