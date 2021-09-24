function gw_set_iterfrec(itfrec::Real=_GITWR_DEFLT_ITERFREC; tout = 60.0)
    
    GitWorkers._repo_update() do

        # to get instant reaction
        _set_pushflag()

        # UPREPO
        expr = quote
            GitWorkers._set_iterfrec($(itfrec))
            rtfile = GitWorkers._local_urlpath(__routine__.file)
            @show rtfile # Test
            GitWorkers._gwrm(rtfile)
		end
        GitWorkers._serialize_repo_rt(expr)
    end

    println("\nWaiting for responce...")
    _waitfor_content_change(_curriter_sysfile(); tout)

    println("\n\nIter frec set to: ", _get_iterfrec())
end