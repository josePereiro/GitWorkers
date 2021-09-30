# ------------------------------------------------------
function _exec_killsigs()
    killsigs = _findin(_is_killsig_name, _local_sigdir(); join = true)
    for killsig in killsigs
        # read signal
        sigdat = _read_toml(killsig)
        pid = get(sigdat, "pid", "")
        unsave = get(sigdat, "unsave", false)

        # find reg
        proc = _find_proc(pid)

        if unsave || _validate_proc(proc) 
            force_kill(pid)
        end
    end
end

# ------------------------------------------------------
function _update_proj()
    try
        # TODO: manage runtime Project
        # Pkg.activate(_urldir())
        # Pkg.add("GitWorkers")
        @show Base.active_project()
        Pkg.update("GitWorkers")
    catch err; @error(err); end
end

# ------------------------------------------------------
function _exec_resetsig()
    resetsig = _local_resetsig_file()
    if isfile(resetsig)
        sigdat = _read_toml(resetsig)
        update = get(sigdat, "update", false)
        if update 
            println("\n\n")
            @info("Updating")
            println("\n\n")
            _update_proj()
        end
        println("\n\n")
        @info("Reseting")
        println("\n\n")
        _server_loop_exit()
    end
end