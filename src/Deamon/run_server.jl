const _GW_MIM_DEAMON_LOOP_FREC = 5.0

## ---------------------------------------------------------------
function run_gitworker_server(;
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        url = "",
        force = false
    )

    ## ------------------------------------------------
    # INSTANTIATE WORKERS
    if !isempty(url)
        urls = (url isa String) ? [url] : url
        for remote_url in urls
            _setup_worker(; sys_root, url = remote_url)
        end
    end

    ## ---------------------------------------------------------------
    # GWDeamon
    dm = GWDeamon(sys_root)
    wid!(dm, _GW_DEAMON_PROC_ID)
    depotdir = depot_dir(dm)
    mkpath(depotdir)

    ## ------------------------------------------------
    # KILL OTHER SERVERS
    force && _safe_killall(dm, _GW_DEAMON_PROC_ID)

    ## ------------------------------------------------
    # RUN SERVER LOOP
    with_logger(dm) do
        
        ## ------------------------------------------------
        # INFO
        @info("Starting deamon", pid = getpid(), depotdir)

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
                wid!(gw, "LODAED_WORKER")

                ## ------------------------------------------------
                # INFO
                @info("In Worker", dir = basename(path))

                ## ------------------------------------------------
                # HANDLE WORKER PROCESS
                _del_invalid_proc_regs(gw)
                _kill_duplicated_procs(gw)

                ## ------------------------------------------------
                # SPAWN WORKER PROCS
                _spawn_gitlink_proc(gw)
                _spawn_tasks_admin_proc(gw)
            
            end # HANDLE EACH WORKER FOLDER

        end # WORKERS LOOP

    end # with_logger

    return nothing
end