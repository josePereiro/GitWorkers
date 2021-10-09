function _run_server_loop_os(;wt = 25.0)
    while true
        try
            # REG PROC
            _reg_server_loop_proc()
        catch err
            _with_server_loop_logger() do
                print("\n\n")
                @error("At server loop os", looppid = getpid(), err = _err_str(err), time = now())
                print("\n\n")
                sleep(3.0) # wait flush
            end
            exit()
        end
        sleep(wt)
    end
end