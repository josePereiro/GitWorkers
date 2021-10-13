# ------------------------------------------------------
function _exec_killsigs()
    killsigs = _filterdir(_is_killsig_name, _local_signals_dir(); join = true)
    for killsig in killsigs

        # read signal
        sigdat = _read_toml(killsig)
        tokill = get(sigdat, "pid", "")
        unsafe = get(sigdat, "unsafe", false)
        isempty(tokill) && return

        # read signal
        print("\n\n")
        procreg = _find_procreg(tokill; procsdir = _local_procs_dir())
        @warn("Executing kill sig", 
            looppid = getpid(), 
            tokill, unsafe, 
            isvalid = _validate_proc(procreg),
            procreg = basename(procreg),
            time = now()
        )
        print("\n\n")

        # Test
        _safe_kill(tokill; unsafe)
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
        print("\n\n")
        @error("At update proj", looppid = getpid(), time = now(), err = _err_str(err))
        print("\n\n")
    end
end

# ------------------------------------------------------
function _exec_resetsig()
    resetsig = _local_resetsig_file()
    if isfile(resetsig)
        sigdat = _read_toml(resetsig)
        update = get(sigdat, "update", false)

        print("\n\n")
        @info("Executing resetsig", looppid = getpid(), update, time = now())
        print("\n\n")

        if update 
            
            print("\n\n")
            @info("Updating project")
            print("\n\n")

            _update_proj()
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

        print("\n\n")
        @info("Executing up_serverlogs_sig", looppid = getpid(), deep, time = now())
        print("\n\n")
        
        # copy the most recent deep logs

        # worker logs
        for logs in [
                _last_server_loop_logs(deep),
                _last_server_main_logs(deep)
            ]
            for local_file in logs
                repo_file = _repover(local_file)
                _cp(local_file, repo_file)
            end
        end

        for deamon_file in _last_server_deamon_logs(deep)
            repo_file = _repo_server_deamon_logs_dir(basename(deamon_file))
            _cp(deamon_file, repo_file)
        end
    end
end