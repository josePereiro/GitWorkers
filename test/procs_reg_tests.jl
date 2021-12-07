let
    gw = GW._test_gw()
    
    wid = "HBKJSDBHK"
    rfile = GW._reg_proc(gw, wid)
    @test isfile(rfile)
    pid = getpid()
    rfile1 = GW._findfirst_proc_reg(gw, pid)
    rfile2 = GW._findfirst_proc_reg(gw, wid)
    @test rfile1 == rfile2

    @test GW._is_valid_proc(gw, pid)
    @test GW._is_valid_proc(gw, wid)

    GW.worker_root(gw) |> GW._rm
end