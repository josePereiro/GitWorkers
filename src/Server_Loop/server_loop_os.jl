function _run_server_loop_os(;wt = 10.0)
    while true
        try
            # REG PROC
            _reg_server_loop_proc()
            sleep(wt)
        catch err
            (err isa InterruptException) && exit()
            _with_server_loop_logger() do
                @error("At server loop os", err = _err_str(err))
            end
            rethrow(err)
        end
    end
end