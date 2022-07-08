function _pull_and_listen(gw::GitWorker, w::AbstractGWAgent; 
        tout = Inf
    )

    t0 = time()
    gl = gitlink(gw)
    wt = 3.0
    try
        while true

            (time() - t0 > tout) && break

            send_force_push_signal(gl) # one push
            
            download(gl; verbose = false) do _
                collect_listeners!(w; from_beginning = true)
                print_listeners(w)
            end

            wt = min(wt + 0.1, 20.0)
            sleep(wt)
        end
        
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end

        
end