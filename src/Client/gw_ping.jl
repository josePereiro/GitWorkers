function gw_ping(n = 10; tout = 60.0, verb = false)
    (n < 1) && return
    t0 = time()

    gw_pull(;verb)
    
    try
        # wait
        _gw_full_sync(; tout, verb)
        
        # print ping
        msg = string("Ping in ", round(time() - t0; sigdigits = 3), " secund(s)")
        @info(msg, remote = _get_url(), curriter = _get_curriter(), ping = n)
        println()

        # recursive
        gw_ping(n - 1;tout, verb)

    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end