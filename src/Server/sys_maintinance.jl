function _check_no_proc_running(hint, n)
    serverprocs = _findin(_local_procsdir()) do file
        _is_procreg_file(file) && contains(file, hint)
    end
    noprocs = length(serverprocs)
    if noprocs != n
        @error("FATAL, $(n) $(hint) registered process(s) expected!!!, found $(noprocs)")
        exit()
    end
end

_check_duplicated_server_main_proc() = _check_no_proc_running(_GITGW_SERVER_MAIN_PROC_TAG, 1)
_check_duplicated_server_loop_proc() = _check_no_proc_running(_GITGW_SERVER_LOOP_PROC_TAG, 1)

function _clear_procs_regs()
    for procreg in _readdir(_local_procsdir(); join = true)
        !_validate_proc(procreg) && _rm(procreg)
    end
end