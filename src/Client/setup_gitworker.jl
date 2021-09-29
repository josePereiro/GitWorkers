## ---------------------------------------------------------------
function _setup_gitworker_local_part(;
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

## ---------------------------------------------------------------
# TODO: connect with config
# init setup
function setup_gitworker(;
        url::AbstractString,
        sys_root::AbstractString,
        force_clonning = false
    )

    # setup
    _setup_gitworker_local_part(;url, sys_root)

    _repo_update(() -> (_touch_dummy(); true);
        commit_msg = "Sync at ($(now()))", 
        force_clonning,
        verb = true
    )
    
    return nothing
end
