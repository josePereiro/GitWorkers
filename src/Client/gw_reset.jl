## ---------------------------------------------------------------
# reset
function gw_reset_server(;update = false, deb = false)
	
	ios = deb ? [stdout] : []
	_repo_update(;ios) do
		
		_set_pushflag()
		_send_resetsig(;update)
		
		return true
	end
end