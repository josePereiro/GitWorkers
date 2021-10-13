function run_gitworker_server(;
        sys_root = homedir(),
        url::Union{Vector{String}, String} = "",
        deb = false
    )

    _set_root!(sys_root)

    # set up all passed urls
    urlv = (url isa String) ? String[url] : url
    for url in urlv
        isempty(url) && continue
        gw_setup_gitworker(; sys_root, url,
            force_clonning = true
        )
    end

    _with_server_deamon_logger() do
        _deamon_loop(; sys_root, deb)
    end

end

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