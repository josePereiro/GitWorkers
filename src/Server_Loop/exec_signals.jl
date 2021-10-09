# ------------------------------------------------------
function _exec_killsigs()
    killsigs = _filterdir(_is_killsig_name, _local_signals_dir(); join = true)
    for killsig in killsigs
        # read signal
        sigdat = _read_toml(killsig)
        pid = get(sigdat, "pid", "")
        unsafe = get(sigdat, "unsave", false)

        _kill_proc(pid; unsafe)
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
        if update 
            _with_server_loop_logger() do
                print("\n\n")
                @info("Updating project")
                print("\n\n")
                _update_proj()
            end
        end
        _with_server_loop_logger() do
            print("\n\n")
            @info("Reseting server loop", looppid = getpid(), time = now())
            print("\n\n")
        end
        _server_loop_exit()
    end
end

# ------------------------------------------------------
function _exec_up_serverlogs_sig()
    sigfile = _local_up_serverlogs_sig_file()
    if isfile(sigfile)
        sigdat = _read_toml(sigfile)
        deep = get(sigdat, "deep", -1)
        deep < 1 && return
        
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