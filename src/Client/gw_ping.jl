function gw_ping(;tout = 60.0, deb = false)

    t0 = time()
    
    # wait
    try
        _waitfor_till_next_iter(;tout)
        remote = _get_url()
        msg = string("Ping in ", round(time() - t0), " secund(s)")
        @info(msg, remote)
        gw_ping(;tout, deb)
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end