function _gw_full_sync(; tout = 60.0, verb = false)
    # Sync
    println("-"^60)
    println("Syncing, curriter: ", _get_curriter())
    timeout = !_waitfor_till_next_iter(;tout, verb)
    timeout && return
    println("Done, curriter: ", _get_curriter())
    println()
end

function gw_sync(n = 1; tout = 60.0, verb = false)
    n = max(n, 1)
    for _ in 1:n
        _gw_full_sync(; tout, verb)
    end
end