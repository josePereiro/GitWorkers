function _gw_up_serverlogs(repo_logs_dir; deep = 2, tout = 120.0, wt = 2.0, filter = _is_log_file, verb = false)
    _repo_update(;verb) do
		
        # reset repo logs
        _rm(repo_logs_dir)

        # send signal
		_set_pushflag()
		_set_up_serverlogs_sig(;deep)
		
		return true
	end

    # following
    try
        timeout = !_waitfor_content_change(repo_logs_dir; tout, wt)
        timeout && return

        for logfile in _last_logs(repo_logs_dir; deep, filter) |> reverse!
            println("\n\n", "log file: ", basename(logfile), "\n\n")
            _print_file(logfile)
        end
    catch err
        (err isa InterruptException) && return
        rethrow(err)
    end
    
end

gw_server_loop_logs(deep = 1; tout = 120.0, wt = 2.0, verb = false) = 
    _gw_up_serverlogs(_repo_server_loop_logs_dir(); deep, tout, wt, filter = _is_server_loop_log_file, verb)

gw_server_main_logs(deep = 1; tout = 120.0, wt = 2.0, verb = false) = 
    _gw_up_serverlogs(_repo_server_main_logs_dir(); deep, tout, wt, filter = _is_server_main_log_file, verb)