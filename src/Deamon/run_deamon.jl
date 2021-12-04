const _GW_MIM_DEAMON_LOOP_FREC = 5.0
const _GW_MAX_DEAMON_LOOP_FREC = 60.0

function run_gitworker_server(;
        url = "",
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        deb = false
    )

    ## ------------------------------------------------
    # INSTANTIATE WORKERS
    if !isempty(url)
        urls = url isa String ? [url] : url
        for remote_url in urls
            _setup_worker(; sys_root, url = remote_url)
        end
    end

    ## ------------------------------------------------
    # GWDeamon
    dm = GWDeamon(sys_root)
    depotdir = depot_dir(dm)
    mkpath(depotdir)
    ptag!(dm, _GW_DEAMON_PROC_ID)

    ## ------------------------------------------------
    # HANDLE PROCESS
    if _is_running(dm, _GW_DEAMON_PROC_ID)
        error("A deamon process is already running!!!")
    end
    _del_invalid_proc_regs(dm)
    _kill_duplicated_procs(dm)
    _reg_proc(dm)

    ## ------------------------------------------------
    # LOOP DEAMON GLOBALS
    loop_frec = _GW_MIM_DEAMON_LOOP_FREC

    ## ------------------------------------------------
    # WORKERS LOOP
    while true

        ## ------------------------------------------------
        # LOOP_FREC
        sleep(loop_frec)

        ## ------------------------------------------------
        # HANDLE DEAMON PROCESS
        _del_invalid_proc_regs(dm)
        _kill_duplicated_procs(dm)
        _reg_proc(dm)

        ## ------------------------------------------------
        # HANDLE EACH WORKER FOLDER
        for path in _readdir(depotdir; join = true)

            ## ------------------------------------------------
            # LOAD WORKER
            gw = _load_worker(path)
            isnothing(gw) && continue

            ## ------------------------------------------------
            # HANDLE WORKER PROCESS
            _spawn_worker_procs(gw; deb)
        end

    end

end