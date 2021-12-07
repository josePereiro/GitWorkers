function _create_client_script(; 
        sys_root, client_root, 
        client_script, server_script, remote_url
    )
    client_tfile = joinpath(@__DIR__, "client_script_template.jl")
    temp::String = read(client_tfile, String)
    temp = replace(temp, "__REMOTE_URL__" => remote_url)
    temp = replace(temp, "__CLIENT_ROOT__" => client_root)
    temp = replace(temp, "__SYS_ROOT__" => sys_root)
    src = replace(temp, "__SERVER_SCRIPT_PATH__" => server_script)
    write(client_script, src)
    return src
end

function _create_server_script(; 
        server_root, remote_url, server_script
    )
    server_tfile = joinpath(@__DIR__, "server_script_template.jl")
    temp::String = read(server_tfile, String)
    temp = replace(temp, "__REMOTE_URL__" => remote_url)
    src = replace(temp, "SERVER_ROOT" => server_root)
    write(server_script, src)
    return src
end

## ---------------------------------------------------------------
function gw_create_devland(; 
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        remote_url = "",
        clear_repos = true, 
        clear_scripts = false,
        verbose = false,
        branch_name = "main"
    )

    
    # ---------------------------------------------------------------
    # upstream_repo
    devland = devland_dir(sys_root)
    
    # ---------------------------------------------------------------
    # upstream_repo
    if isempty(remote_url)
        _, remote_url = GitLinks.create_local_upstream(devland; 
            verbose, branch_name
        )
    end

    client_root = joinpath(devland, "client_root")
    server_root = joinpath(devland, "server_root")
    
    if clear_repos
        _rm(client_root)
        _rm(server_root)
    end

    @info("Setting server")
    server_gw = GitWorker(server_root, remote_url)
    gw_setup(server_gw)

    @info("Setting client")
    client_gw = GitWorker(client_root, remote_url)
    gw_setup(client_gw)

    # ---------------------------------------------------------------
    # scripts
    client_script = joinpath(devland, "client.jl")
    server_script = joinpath(devland, "server.jl")

    if clear_scripts || !isfile(client_script) 
        _rm(client_script)
        _create_client_script(; sys_root, client_root, client_script, server_script, remote_url)
    end

    # server script
    if clear_scripts || !isfile(server_script) 
        _rm(server_script)
        _create_server_script(;server_root, remote_url, server_script)
    end
    
    @info("DevLand setup", client_script, server_script)

    return (;client_gw, server_gw)
end