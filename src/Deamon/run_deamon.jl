function run_deamon(; sys_root = _GW_SYSTEM_DFLT_ROOT)

    loop_frec = 5.0

    depotdir = sdepot_dir(sys_root)
    mkpath(depotdir)

    ## ------------------------------------------------
    # CHECK PROC

    while true

        ## ------------------------------------------------
        # WAIT
        sleep(loop_frec)
        
        ## ------------------------------------------------
        # HANDLE ALL WORKERS
        for path in _readdir(depotdir; join = true)
            !isdir(path) && continue
            gwtoml = _worker_file(path)
            !isfile(gwtoml) && continue
        end

    end

end