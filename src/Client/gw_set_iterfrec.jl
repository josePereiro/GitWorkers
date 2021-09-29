function gw_set_iterfrec(itfrec::Real=_GITWR_DEFLT_ITERFREC; tout = 60.0)
    
    _repo_update() do

        _set_pushflag()
        _set_iterfrec(itfrec)
        return true
    end

    println("\nWaiting for responce...")
    _waitfor_till_next_iter(;tout)

    println("\n\nIter frec set to: ", _get_iterfrec())
end