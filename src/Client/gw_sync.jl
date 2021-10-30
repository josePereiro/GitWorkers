function _gw_full_sync(; tout = 60.0, verb = false)
    verb && println("_gw_full_sync")
    # Sync
    println("-"^60)
    println("Syncing, curriter: ", _get_curriter())
    timeout = !_waitfor_till_next_iter(;tout, verb)
    timeout && return false
    println("Done, curriter: ", _get_curriter())
    println()
    return true
end

function gw_sync(n = 1; tout = 60.0, verb = false)
    n = max(n, 1)
    ok = false
    for _ in 1:n
        ok |= _gw_full_sync(; tout, verb)
    end
    return ok
end