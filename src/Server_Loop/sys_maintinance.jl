function _check_no_proc_running(hint, n)
    noprocs = _no_proc_running(hint)
    if noprocs != n
        print("\n\n")
        try
            error("FATAL, $(n) $(hint) registered process(s) expected!!!, found $(noprocs)")
        catch err
            print("\n\n")
            @error("At cheking proc number", pid = getpid(), time = now(), err = _err_str(err))
            print("\n\n")
            sleep(3.0) # wait flush
        end
        exit()
    end
end

_check_duplicated_server_main_proc() = _with_server_main_logger() do
    _check_no_proc_running(_GITGW_SERVER_MAIN_PROC_TAG, 1)
end

_check_duplicated_server_loop_proc() = _with_server_loop_logger() do
    _check_no_proc_running(_GITGW_SERVER_LOOP_PROC_TAG, 1)
end

function _clear_invalid_procs_regs()
    for procreg in _readdir(_local_procs_dir(); join = true)
        !_validate_proc(procreg) && _rm(procreg)
    end
end

_clear_local_signals() = _rm(_local_signals_dir())
_clear_local_tasks() = _rm(_local_tasks_cmds_dir())