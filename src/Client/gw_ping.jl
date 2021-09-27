function gw_ping(;tout = 60.0)

    t0 = time()
    
    _repo_update(_set_pushflag)
    
    # wait
    try
        _waitfor_till_next_iter(;tout)
        println("\n\nPing in ", round(time() - t0), " secund(s)")
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end