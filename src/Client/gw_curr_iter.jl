function gw_curr_iter(; verb = false)

    # Update 
    _gw_pull(; verb)

    # println
    println("curriter: ", _get_curriter())
end