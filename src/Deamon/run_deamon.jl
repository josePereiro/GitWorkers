const _GW_MIM_DEAMON_LOOP_FREC = 5.0
const _GW_MAX_DEAMON_LOOP_FREC = 60.0

function run_deamon(;
        sys_root = _GW_SYSTEM_DFLT_ROOT
    )

    ## ------------------------------------------------
    # GWDeamon
    dm = GWDeamon(sys_root)
    depotdir = depot_dir(dm)
    mkpath(depotdir)

    ## ------------------------------------------------
    # HANDLE PROCESS
    _up_procs_from_disk!(dm)
    pcount = _registered_procs_count(dm, _GW_DEAMON_PROC_ID)
    if pcount > 0
        error("A deamon is already running, got pcount = '$(pcount)'")
    end
    _reg_proc!(dm, _GW_DEAMON_PROC_ID)

    ## ------------------------------------------------
    # LOOP DEAMON GLOBALS
    loop_frec = _GW_MIM_DEAMON_LOOP_FREC

    ## ------------------------------------------------
    # WORKER
    gws = GitWorker[]

    while true

        ## ------------------------------------------------
        # LOOP_FREC
        sleep(loop_frec)

        ## ------------------------------------------------
        # HANDLE DEAMON PROCESS
        _up_procs_from_disk!(dm)
        pcount = _registered_procs_count(dm, _GW_DEAMON_PROC_ID)
        if pcount > 1
            # TODO: do not die, kill the other deamon
            error("Too many deamons running, got pcount = '$(pcount)'")
        end
        _reg_proc!(dm, _GW_DEAMON_PROC_ID)

        ## ------------------------------------------------
        # HANDLE EACH WORKER FOLDER
        for path in _readdir(depotdir; join = true)

            ## ------------------------------------------------
            # LOAD WORKER
            !isdir(path) && continue
            gwtoml = _worker_file(path)
            !isfile(gwtoml) && continue
            gw = _gw_from_toml(gwtoml)
            isnothing(gw) && continue

            ## ------------------------------------------------
            # HAnDLE WORKER PROCESS
            _up_procs_from_disk!(gw)
            pcount = _registered_procs_count(gw, _GW_DEAMON_PROC_ID)
            if pcount 

            end
        end

    end

end