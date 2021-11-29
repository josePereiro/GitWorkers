let
    gw = GW._test_gw()
    
    ptag = "HBKJSDBHK"
    pid = getpid()
    rfile = GW._reg_proc!(gw, pid, ptag)
    @test isfile(rfile)
    sdat1 = GW.get_sdat(gw, rfile)
    sdat2 = GW._find_proc_reg(gw, pid)
    sdat3 = GW._find_proc_reg(gw, ptag)
    empty!(gw.dat)
    GW._up_procs_from_disk(gw)
    sdat4 = GW.get_sdat(gw, rfile)

    for dat in [sdat1, sdat2, sdat3, sdat4]
        @test haskey(dat, "lstart")
    end

    @test GW._validate_proc(gw, pid)
    @test GW._validate_proc(gw, ptag)
    @test GW._validate_proc(gw, rfile)

    GW.worker_dir(gw) |> GW._rm
end