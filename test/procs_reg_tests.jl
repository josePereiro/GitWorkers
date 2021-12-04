let
    gw = GW._test_gw()
    
    ptag = "HBKJSDBHK"
    rfile = GW._reg_proc(gw, ptag)
    @test isfile(rfile)
    pid = getpid()
    rfile1 = GW._find_proc_reg(gw, pid)
    rfile2 = GW._find_proc_reg(gw, ptag)
    @test rfile1 == rfile2

    @test GW._is_valid_proc(gw, pid)
    @test GW._is_valid_proc(gw, ptag)

    GW.worker_root(gw) |> GW._rm
end