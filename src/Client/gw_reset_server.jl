## ---------------------------------------------------------------
# reset
function gw_reset_server(;update = false, verb = false)
	
	_repo_update(;verb) do
		
		_set_pushflag()
		_set_resetsig(;update)
		
		return true
	end
end