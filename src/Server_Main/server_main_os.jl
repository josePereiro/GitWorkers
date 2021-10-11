function _run_server_main_os(; wt = 25.0)
    while true
        try
            # handle proc reg
            _with_server_main_logger() do
                _reg_server_main_proc()
                _clear_invalid_procs_regs()
                _check_duplicated_server_main_proc()
                _write_globals()
            end

        catch err
            _with_server_main_logger() do
                print("\n\n")
                @error("At server main os", mainpid = getpid(), err = _err_str(err), time = now())
                print("\n\n")
                sleep(3.0) # wait flush
            end
        end

        sleep(wt)
    end
end