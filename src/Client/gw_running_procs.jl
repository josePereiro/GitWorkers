function _gw_running_procs(;verb = false, tout = 120)

	# Do a full sync
	_gw_full_sync(; tout, verb)
	
	# print task procs
	println("Running processes\n")
	for file in _readdir(_repo_procs_dir(); join = true)
		!_is_procreg_file(file) && return
		println("proc: ", basename(file))
		println(read(file, String))
		println()
	end
end

function gw_running_procs(tries = 1;
		verb = false, tout = 120,
		wt = 3.0
	)
	while true
		try
			_gw_running_procs(;verb, tout)
			tries -= 1; (tries < 1) && return
			sleep(wt)
		catch err
			(err isa InterruptException) && return
			rethrow(err)
		end
	end
end