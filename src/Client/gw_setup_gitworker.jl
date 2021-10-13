## ---------------------------------------------------------------
function _local_setup(;
        url::AbstractString,
        sys_root::AbstractString
    )

    _mkpath(sys_root)

    # globals
    _set_url!(url)
    _set_root!(sys_root)
    _write_globals()

    # initial setup
    _reset_file_trakers!()

end
 
## ---------------------------------------------------------------
# TODO: connect with config
# init setup
function gw_setup_gitworker(;
        url::AbstractString,
        sys_root::AbstractString = homedir(),
        force_clonning = false
    )

    # setup
    _local_setup(;sys_root, url)

    _repo_update(() -> (_touch_dummy(); true);
        commit_msg = "Sync at ($(now()))", 
        force_clonning,
        verb = true
    )
    
    return nothing
end
