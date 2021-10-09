# ------------------------------------------------------
function _exec_killsigs()
    killsigs = _filterdir(_is_killsig_name, _local_signals_dir(); join = true)
    for killsig in killsigs

        # read signal
        sigdat = _read_toml(killsig)
        tokill = get(sigdat, "pid", "")
        unsafe = get(sigdat, "unsave", false)

        # read signal
        _with_server_loop_logger() do
            print("\n\n")
            @info("Executing kill sig", looppid = getpid(), tokill, unsafe, time = now())
            print("\n\n")
        end

        _kill_proc(tokill; unsafe)
    end
end

# ------------------------------------------------------
function _update_proj()
    try
        # TODO: manage runtime Project
        # Pkg.activate(_urldir())
        # Pkg.add("GitWorkers")
        Pkg.update("GitWorkers")
    catch err
        _with_server_loop_logger() do
            print("\n\n")
            @error("At update proj", looppid = getpid(), time = now(), err = _err_str(err))
            print("\n\n")
        end
    end
end

# ------------------------------------------------------
function _exec_resetsig()
    resetsig = _local_resetsig_file()
    if isfile(resetsig)
        sigdat = _read_toml(resetsig)
        update = get(sigdat, "update", false)
        
        _with_server_loop_logger() do
            print("\n\n")
            @info("Executing resetsig", looppid = getpid(), update, time = now())
            print("\n\n")
        end

        if update 
            _with_server_loop_logger() do
                print("\n\n")
                @info("Updating project")
                print("\n\n")
                _update_proj()
            end
        end

        _server_loop_exit()
    end
end

# ------------------------------------------------------
function _exec_up_serverlogs_sig()
    sigfile = _local_up_serverlogs_sig_file()
    if isfile(sigfile)
        sigdat = _read_toml(sigfile)
        deep = max(get(sigdat, "deep", -1), 1)

        _with_server_loop_logger() do
            print("\n\n")
            @info("Executing up_serverlogs_sig", looppid = getpid(), deep, time = now())
            print("\n\n")
        end
        
        # copy the most recent deep logs
        for logs in [
                _last_server_loop_logs(deep),
                _last_server_main_logs(deep)
            ]
            for local_file in logs
                repo_file = _repover(local_file)
                _cp(local_file, repo_file)
            end
        end
    end
end