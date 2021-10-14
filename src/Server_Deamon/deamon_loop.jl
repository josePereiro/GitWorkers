function _deamon_loop(;
        sys_root = homedir(),
        deb = false
    )


    # welcome
    print("\n\n")
    @info("Deamon started", deamonpid = getpid(), sys_root, time = now())
    print("\n\n")

    # deamon loop
    _homedir = _gitworkers_homedir()
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
        print("\n\n")
        @info("Deamon running", deamonpid = getpid(), sys_root, time = now())
        print("\n\n")

        sleep(25.0)
    end
end