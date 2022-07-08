const _GW_MIM_DEAMON_LOOP_FREC = 5.0

## ---------------------------------------------------------------
function run_gitworker_server(;
        sys_root = homedir(),
        url = "",
        force = false, 
        verbose = true, 
        ntiters = Inf
    )

    # ------------------------------------------------
    # INSTANTIATE NEW WORKERS
    if !isempty(url)
        urls = (url isa String) ? [url] : url
        for remote_url in urls
            GitWorker(remote_url, sys_root; write = true)
        end
    end

    # ------------------------------------------------
    # DEAMON
    dm = GWDeamon(sys_root; write = true)
    collect_workers!(dm)

    ## ------------------------------------------------
    # MAINTINANCE
    del_invalid_proc_registries(dm)
    if force 
        safe_killall(dm) # kill others
        clear_proc_regs(dm)
        sleep(1.0)
    end
    duplicated = duplicated_procs(dm)
    if length(duplicated) > 0
        _, pid, _ = _parse_proc_reg_name(first(duplicated))
        error("Another deamon is running at process $(pid)")
    end
    write_proc_reg(dm)

    ## ------------------------------------------------
    # INIT
    verbose && print_listeners!(dm; from_beginning = false) # init listeners

    ## ------------------------------------------------
    # INFO
    log_info(dm, "Starting deamon";
        pid = getpid(), 
        depotdir = gitworkers_dir(dm)
    )

    verbose && print_listeners!(dm; from_beginning = true)

    
    ## ------------------------------------------------
    # LOOP
    it = 0
    wt = 5.0
    while it < ntiters

        it += 1

        # INFO
        log_info(dm, "SERVER ITER"; it, pid = getpid())

        ## ------------------------------------------------
        # DEAMON MAINTINANCE
        del_invalid_proc_registries(dm)
        safe_killall(dm)
        write_proc_reg(dm)

        ## ------------------------------------------------
        # WORKERS LOOP
        collect_listeners!(dm; from_beginning = true)
        for (_, gw) in collect_workers!(dm)

            # WORKER MAINTINANCE (Independet from pid)
            del_invalid_proc_registries(gw)

            # SPAWN WRIKER PROCS
            !is_running(gw) && _spawn_worker_proc(dm, gw)

            # PRINT
            verbose && print_listeners(dm)

        end

        # WAIT
        sleep(wt)
        
    end
    
    
    ## ------------------------------------------------
    return dm

end

## ---------------------------------------------------------------
# function run_gitworker_server(;
#         sys_root = homedir(),
#         url = "",
#         force = false
#     )

#     ## ------------------------------------------------
#     # KILL OTHER SERVERS
#     # force && _safe_killall(dm, _GW_DEAMON_PROC_ID)

#     ## ------------------------------------------------
#     # PRINT TRACKER
#     # @async while true
#     #     _track_dir(_is_log_file, logs_dir(dm))
#     #     _print_tracked_paths()
#     #     sleep(5.0)
#     # end

#     ## ------------------------------------------------
#     # RUN SERVER LOOP
#     with_logger(dm) do
        
#         # ## ------------------------------------------------
#         # # INFO
#         # @info("Starting deamon", pid = getpid(), depotdir = depot_dir(dm))

#         # ## ------------------------------------------------
#         # # HANDLE PROCESS
#         # if _is_running(dm, _GW_DEAMON_PROC_ID)
#         #     error("A deamon process is already running!!!")
#         # end
#         # _del_invalid_proc_regs(dm)
#         # _kill_duplicated_procs(dm)
#         # _reg_proc(dm)

#         # ## ------------------------------------------------
#         # # LOOP DEAMON GLOBALS
#         # loop_frec = _GW_MIM_DEAMON_LOOP_FREC

#         # ## ------------------------------------------------
#         # # WORKERS LOOP
#         # while true

#         #     ## ------------------------------------------------
#         #     # LOOP_FREC
#         #     sleep(loop_frec)

#         #     ## ------------------------------------------------
#         #     # HANDLE DEAMON PROCESS
#         #     _del_invalid_proc_regs(dm)
#         #     _kill_duplicated_procs(dm)
#         #     _reg_proc(dm)

#         #     ## ------------------------------------------------
#         #     # HANDLE EACH WORKER FOLDER
#         #     _foreach_workers(dm) do gw

#         #         ## ------------------------------------------------
#         #         # WORKER ID
#         #         wid!(gw, "LOADED_WORKER")

#         #         ## ------------------------------------------------
#         #         # INFO
#         #         @info("In Worker", dir = agent_dir(gw))

#         #         ## ------------------------------------------------
#         #         # HANDLE WORKER PROCESS
#         #         _del_invalid_proc_regs(gw)
#         #         _kill_duplicated_procs(gw)

#         #         ## ------------------------------------------------
#         #         # SPAWN WORKER PROCS
#         #         _spawn_gitlink_proc(gw)
#         #         _spawn_tasks_admin_proc(gw)

#         #         return nothing
            
#         #     end # HANDLE EACH WORKER FOLDER

#         # end # WORKERS LOOP

#     end # with_logger

#     return nothing
# end