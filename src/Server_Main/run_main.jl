function _run_main(;
        url::AbstractString,
        sys_root::AbstractString = homedir()
    )

    # ---------------------------------------------------------------
    # SETUP
    gw_setup_client(;sys_root, url)
    
    # ---------------------------------------------------------------
    _with_server_main_logger() do
        _main_loop(sys_root, url)
    end

end

