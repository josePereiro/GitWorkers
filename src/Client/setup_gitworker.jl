## ---------------------------------------------------------------
# TODO: connect with config
# init setup
function setup_gitworker(;
        url::AbstractString,
        sys_home::AbstractString = homedir()
    )

    # global
    _set_url!(url)
    _set_root!(sys_home)
    
    # pull
    _touch() = write(_gitwr_urldir("touch"), _gen_id())
    ret = _try_sync(_touch; 
        msg = "Setting up at $(now())", 
        att = 5,
        startup = String[], # TODO: connect with config 
        ios = [stdout], 
        force_clonning = false, 
        pull = true, 
        push = true
    )
    return nothing
end
