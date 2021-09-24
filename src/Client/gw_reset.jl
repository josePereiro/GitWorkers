## ---------------------------------------------------------------
# reset
let

	_url = GitWorkers._get_url()
    _sys_root = GitWorkers._get_root()
	
	GitWorkers._repo_update() do
		
		# to fast react
		GitWorkers._set_iterfrec(0.0)
		GitWorkers._clear_rts()

		# UPREPO ROUTINE
		expr = quote
			# rt info
			rtid = __routine__.id
			rtfile = __routine__.file

			# welcome
			println("\n\n")
			@info("Reseting server", rtid)

			# if file exist return
			datfn = GitWorkers._rtdata_file(rtid, "RESET.OLD_SERVER")
			isfile(datfn) && return

			_save_rtdata(rtid, "RESET.OLD_SERVER", 
				(;server_pid = getpid(), tag_time = time())
			)

			# back to default pushfrec
			GitWorkers._set_iterfrec(600.0)
		end
		GitWorkers._serialize_repo_rt(expr)

		# UPLOCAL ROUTINE
		expr = quote
			rtid = __routine__.id
			rtfile = __routine__.file

			println("\n\n")
			@info("Hiii From local", rtid, rtfile)
			println("\n\n")

		end
		GitWorkers._serialize_local_rt(expr)
	end
end