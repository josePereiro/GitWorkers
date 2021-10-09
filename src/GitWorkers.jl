module GitWorkers
    
    import LibGit2
    import TOML
    import Pkg
    import ExternalCmds

    using Dates
    using Serialization
    using LoggingExtras

    include("Client/gw_curr_iter.jl")
    include("Client/gw_follow.jl")
    include("Client/gw_last_task.jl")
    include("Client/gw_spawn.jl")
    include("Client/gw_push.jl")
    include("Client/gw_ping.jl")
    include("Client/gw_pull.jl")
    include("Client/gw_reset_server.jl")
    include("Client/gw_running_procs.jl")
    include("Client/gw_setup_client.jl")
    include("Client/gw_test_task.jl")
    include("Client/gw_send_killsig.jl")
    include("Client/gw_up_serverlogs.jl")

    export gw_setup_client, 
        @gw_spawn, gw_follow,
        gw_running_procs,
        gw_curr_iter,
        gw_last_task, 
        gw_test_task,
        gw_push, gw_ping, gw_pull, 
        gw_server_loop_logs,
        gw_server_main_logs,
        gw_reset_server, gw_clear_rts, gw_send_killsig

    include("ExternalCmds/utils.jl")
    
    include("Core/utils.jl")
    include("Core/config.jl")
    include("Core/gen_id.jl")
    include("Core/kill_sysproc.jl")
    include("Core/sys_globals.jl")
    include("Core/repo_update.jl")
    include("Core/sync_script.jl")
    include("Core/nuke_script.jl")
    include("Core/logging.jl")
    include("Core/proc_regs.jl")
    
    include("Signals/utils.jl")
    include("Signals/killsig.jl")
    include("Signals/resetsig.jl")
    include("Signals/up_serverlogs_sig.jl")

    include("Tasks/long_task_os.jl")
    include("Tasks/long_tasks.jl")
    include("Tasks/set_long_task.jl")
    include("Tasks/spawn_long_task.jl")
    include("Tasks/task_out.jl")
    include("Tasks/procs.jl")
    
    include("FileSystem/utils.jl")
    include("FileSystem/dirtree.jl")
    
    include("Server_Loop/atexit.jl")
    include("Server_Loop/download_data.jl")
    include("Server_Loop/exec_signals.jl")
    include("Server_Loop/loop_control.jl")
    include("Server_Loop/procs.jl")
    include("Server_Loop/repo_maintinance.jl")
    include("Server_Loop/server_loop_os.jl")
    include("Server_Loop/server_loop.jl")
    include("Server_Loop/spawn_long_tasks.jl")
    include("Server_Loop/sys_maintinance.jl")
    include("Server_Loop/upload_data.jl")
    include("Server_Loop/logging.jl")
    
    include("Server_Main/procs.jl")
    include("Server_Main/run_main.jl")
    include("Server_Main/logging.jl")
    include("Server_Main/server_main_os.jl")
    
    include("Server_Deamon/run_deamon.jl")
    include("Server_Deamon/spawn_main.jl")
    include("Server_Deamon/logging.jl")
    include("Server_Deamon/procs.jl")
    
    include("Events/FileTracker.jl")
    include("Events/waitfor.jl")
    
    include("Test/test_repos.jl")
    include("Test/monkey_delete.jl")
    include("Test/create_test_engine.jl")

    function __init__()
        !Sys.isunix() && error("Non-unix systems are not yet supported!")
    end
    
end
