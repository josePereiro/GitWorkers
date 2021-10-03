## ---------------------------------------------------------------
function _gw_setup_client_local_part(;
        url::AbstractString,
        sys_root::AbstractString
    )

    mkpath(sys_root)

     # globals
     _set_url!(url)
     _set_root!(sys_root)
     _set_wutime!()
 
     # initial setup
     _reset_file_trakers!()

end

# Compat with old versions
# TODO: remove when stable
_setup_gitworker_local_part = _gw_setup_client_local_part
 
## ---------------------------------------------------------------
# TODO: connect with config
# init setup
function gw_setup_client(;
        url::AbstractString,
        sys_root::AbstractString = homedir(),
        force_clonning = false
    )

    # setup
    _gw_setup_client_local_part(;url, sys_root)

    _repo_update(() -> (_touch_dummy(); true);
        commit_msg = "Sync at ($(now()))", 
        force_clonning,
        verb = true
    )
    
    return nothing
end
