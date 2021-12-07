const _GW_MIM_DEAMON_LOOP_FREC = 5.0
const _GW_MAX_DEAMON_LOOP_FREC = 60.0

## ---------------------------------------------------------------
function _create_deamon_proc_script(scrfile::String; 
        sys_root = "",
        force::Bool = false
    )

    tfile = joinpath(@__DIR__, "deamon_script_template.jl")
    src = read(tfile, String)
    src = replace(src, "__SYS_ROOT__" => sys_root)
    src = replace(src, "__FORCE__" => string(force))
    _mkdir(scrfile)
    write(scrfile, src)

    return scrfile
end

## ---------------------------------------------------------------
function _run_deamon(dm::GWDeamon)
    
    ## ------------------------------------------------
    wid!(dm, _GW_DEAMON_PROC_ID)

    ## ------------------------------------------------
    depotdir = depot_dir(dm)
    mkpath(depotdir)

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
            # INFO
            @info("In Worker", dir = basename(path))

            ## ------------------------------------------------
            # HANDLE WORKER PROCESS
            _spawn_worker_procs(gw)
        end

    end

    return nothing
end

## ---------------------------------------------------------------
function run_gitworker_server(;
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        url = "",
        force = false
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
    scrfile = tempname()
    _create_deamon_proc_script(scrfile; sys_root, force)
    
    projdir = pkgdir(GitWorkers)
    jlcmd = `julia --startup-file=no --project=$(projdir) $(scrfile)`
    run(jlcmd; wait = true)

    return nothing
end

