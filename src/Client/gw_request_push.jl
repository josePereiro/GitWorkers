function gw_request_push(tout = 0.1; verbose = true)
    okflag = send_force_push_signal(gitlink(gw_curr()); tout) # one push

    if verbose
        okflag ? 
            @info("Push signal sended") :
            @warn("Signaling failed!")
    end

    return okflag
end