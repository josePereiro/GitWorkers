## ---------------------------------------------------------------
# reset
function _gw_reset_server(;update = false)
	
	# Finish this!!!
	_repo_update() do
		
		_set_pushflag()
		_send_resetsig(;update)
		
	end
end