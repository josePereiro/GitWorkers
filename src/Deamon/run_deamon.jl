const _GW_MIM_DEAMON_LOOP_FREC = 5.0
const _GW_MAX_DEAMON_LOOP_FREC = 60.0

## ---------------------------------------------------------------
function _create_deamon_proc_script(scrfile::String; 
        sys_root = "",
        clear_script::Bool = true, deb::Bool = false, 
        force::Bool = false
    )

    tfile = joinpath(@__DIR__, "deamon_script_template.jl")
    src = read(tfile, String)
    src = replace(src, "__CLEAR_SCRIPT__" => string(clear_script))
    src = replace(src, "__SYS_ROOT__" => sys_root)
    src = replace(src, "__DEB__" => string(deb))
    src = replace(src, "__FORCE__" => string(force))
    _mkdir(scrfile)
    write(scrfile, src)

    println(src)

    return scrfile
end


function _run_server(dm::GWDeamon;
        deb = false,
    )
    
    ## ------------------------------------------------
    @show dm
    ptag!(dm, _GW_DEAMON_PROC_ID)

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
            # HANDLE WORKER PROCESS
            _spawn_worker_procs(gw; deb)
        end

    end

    return nothing
end

function run_gitworker_server(;
        sys_root = _GW_SYSTEM_DFLT_ROOT,
        url = "",
        deb = false, 
        force = false,
        detach = false,
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
    _create_deamon_proc_script(scrfile; sys_root, deb, force)
    
    projdir = pkgdir(GitWorkers)
    jlcmd = "julia --startup-file=no --project=$(projdir) $(scrfile)"
    run_fun = deb ? _run_bash : _spawn_bash
    # run_fun(jlcmd; detach)
    @show jlcmd
    # _run_bash(jlcmd)
    run(`julia --startup-file=no --project=$(projdir) $(scrfile)`; wait = true)

    return nothing
end

