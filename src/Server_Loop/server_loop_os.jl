function _run_server_loop_os(;wt = 25.0)
    while true
        try
            # REG PROC
            _reg_server_loop_proc()
        catch err
            
            print("\n\n")
            @error("At server loop os", looppid = getpid(), err = _err_str(err), time = now())
            print("\n\n")
            sleep(3.0) # wait flush

            exit()
        end
        sleep(wt)
    end
end