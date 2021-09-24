function gw_ping(n=5)

    n = float(max(n, 1))

    gw_pull()
    
    GitWorkers._repo_update() do
        # to get instant reaction
        GitWorkers._set_iterfrec(0.0)

        # UPREPO
        expr = quote

            curr_iter = GitWorkers._get_curriter()
            if (curr_iter > $(curr_iter0) + $(n))
                
                # del routine
                rtfile = GitWorkers._local_urlpath(__routine__.file)
                @show rtfile # Test
                GitWorkers._gwrm(rtfile)

            end
            # to get instant reaction
            GitWorkers._set_pushflag()
		end
        GitWorkers._serialize_repo_rt(expr)

    end

    # wait
    try
        t0 = time()
        c = 1
        while true
            _waitfor_content_change(_dummy_file())
            println("\n\nPing: ", c, " of ", n)
            c += 1
        end
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
end