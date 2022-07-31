function gw_request_push(ncommits = 1; verbose = true)
    okflag = send_force_push_signal(gitlink(gw_curr()); ncommits)

    if verbose
        okflag ? 
            @info("Push signal sended, ncommits: $(ncommits)") :
            @warn("Signaling failed!")
    end

    return okflag
end