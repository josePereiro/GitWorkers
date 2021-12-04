let
    gw = GW._test_gw()
    GW.worker_root(gw) |> GW._rm
    
    wt = 5
    proc = run(`sleep $(wt)`; wait = false)
    pid = GW._try_getpid(proc)
    @test pid != -1

    ptag = "TEST"
    rfile = GW._reg_proc(gw, ptag, pid)

    @test GW._safe_kill(gw, pid)

    # wait
    dead_flag = false
    for _ in 1:wt
        dead_flag = !GW._is_valid_proc(gw, pid)
        dead_flag && break
        sleep(1.0)
    end
    @test dead_flag

    GW.worker_root(gw) |> GW._rm
end