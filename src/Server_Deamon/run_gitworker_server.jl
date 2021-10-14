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

