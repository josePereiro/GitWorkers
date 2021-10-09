function run_gitworker_server(;
        sys_root = homedir(), 
        deb = true
    )

    _set_root!(sys_root)
    _homedir = _gitworkers_homedir()

    # welcome
    _with_server_deamon_logger() do
        print("\n\n")
        @info("Deamon started", deamonpid = getpid(), sys_root, time = now())
        print("\n\n")
    end

    # deamon loop
    while true

        for urldir in _readdir(_homedir; join = true)
            !isdir(urldir) && continue

            globs = _read_globals(urldir)
            isempty(globs) && continue
            
            url = get(globs, "url", "")
            isempty(url) && continue

            _spawn_main(;sys_root, url, sync = deb)

        end

        # welcome
        _with_server_deamon_logger() do
            print("\n\n")
            @info("Deamon running", deamonpid = getpid(), sys_root, time = now())
            print("\n\n")
        end

        sleep(25.0)
    end

end