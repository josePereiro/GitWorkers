const _GW_MIM_DEAMON_LOOP_FREC = 5.0

## ---------------------------------------------------------------
function run_gitworker_server(
        sys_root = homedir();
        url = "",
        force = false, 
        verbose = true
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
    dm = GWDeamon(sys_root)

    ## ------------------------------------------------
    # KILL OTHER SERVERS
    # force && _safe_killall(dm, _GW_DEAMON_PROC_ID)

    ## ------------------------------------------------
    # INIT
    collect_workers!(dm)
    verbose && print_listeners!(dm) # init listeners

    with_logger(dm) do

        ## ------------------------------------------------
        # INFO
        @info("Starting deamon", 
            pid = getpid(), 
            depotdir = gitworkers_dir(dm)
        )

    end

    verbose && print_listeners!(dm)
    
    ## ------------------------------------------------
    # LOOP
    for it in 1:10

        # INFO
        with_logger(dm) do
            @info("New iter", it, pid = getpid())
        end
        
        verbose && print_listeners!(dm)

        sleep(1.0)
    end
    
    
    ## ------------------------------------------------
    return dm

end

## ---------------------------------------------------------------
# function run_gitworker_server(;
#         sys_root = _GW_SYSTEM_DFLT_ROOT,
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