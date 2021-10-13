function _gw_running_procs(;verb = false, tout = 120)

	# Do a full sync
	println("-"^60)
	println("Syncing, curriter: ", _get_curriter())
	timeout = !_waitfor_till_next_iter(;verb, tout)
	timeout && return
	println("Done, curriter: ", _get_curriter())
	println()
	
	# print task procs
	println("Running processes\n")
	for file in _readdir(_repo_procs_dir(); join = true)
		!_is_procreg_file(file) && return
		println("proc: ", basename(file))
		println(read(file, String))
		println()
	end
end

function gw_running_procs(;verb = false, repeat = true, tout = 120)
	try
		while true
			_gw_running_procs(;verb, tout)

			!repeat && break
			sleep(3.0)
		end
	catch err
		(err isa InterruptException) && return
		rethrow(err)
	end
end