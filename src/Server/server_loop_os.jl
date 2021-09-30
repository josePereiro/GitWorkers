function _run_server_loop_os(;wt = 10.0)
    _reg_server_loop_proc()
    while true
        # REG PROC
        _reg_server_loop_proc()
        sleep(wt)
    end
end