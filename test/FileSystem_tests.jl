let	
	sys_root = joinpath(tempdir(), "gitworkers_testland")
	url = "github.com/repo"

	GitWorkers._local_setup(;sys_root, url)
	try

		subpath = joinpath("Bla", "blo")
		full = GitWorkers._urldir(subpath)
		relfn = GitWorkers._rel_urlpath(full)
		@test GitWorkers._native_urlpath(relfn) == full
		
		relfn = GitWorkers._rel_urlpath(subpath)
		@test GitWorkers._native_urlpath(relfn) == full

	finally
		rm(sys_root; recursive = true, force = true)
	end

end