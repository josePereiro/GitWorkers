## ---------------------------------------------------------------
# reset
function gw_reset_server(;update = false, verb = false)
	println("-"^60)
	println("Reseting, update = ", update)
	_repo_update(;verb) do
		_set_pushflag()
		_set_resetsig(;update)
		return true
	end
	
	println("\n")
	println("-"^60)
	println("Pinging")
	gw_ping()
end