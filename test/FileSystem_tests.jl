@testset "FileSystem" begin
    
    sys_root = tempdir()
	url = "github.com/repo"

	GitWorkers._gw_setup_client_local_part(;url, sys_root)
	try

		subpath = joinpath("Bla", "blo")
		full = GitWorkers._urldir(subpath)
		relfn = GitWorkers._rel_urlpath(full)
		@test GitWorkers._native_urlpath(relfn) == full
        
		relfn = GitWorkers._rel_urlpath(subpath)
		@test GitWorkers._native_urlpath(relfn) == full

	finally
		rm(joinpath(sys_root, ".gitworkers"); recursive = true, force = true)
	end

end
