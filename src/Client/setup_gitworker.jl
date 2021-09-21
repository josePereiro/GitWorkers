## ---------------------------------------------------------------
# TODO: connect with config
# init setup
function setup_gitworker(;
        url::AbstractString,
        sys_root::AbstractString
    )

    # globals
    _set_url!(url)
    _set_root!(sys_root)

    # setup
    _reset_file_trakers!()
    _del_gitwr_tempfiles()
    _del_gitwr_stagedir()
    
    # pull
    _create_dummy()
    _gwsync(; 
        msg = "Setting up at $(now())", 
        startup = String[], # TODO: connect with config 
        ios = [stdout], 
        force_clonning = false, 
        att = 1 # Test
    )
    return nothing
end
