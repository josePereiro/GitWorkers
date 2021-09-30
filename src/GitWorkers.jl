module GitWorkers
    
    import LibGit2
    import TOML
    # import ArgParse
    import Pkg

    using FilesTreeTools
    using Dates
    using Serialization
    import ExternalCmds


    include("Client/gw_spawn.jl")
    include("Client/gw_push.jl")
    include("Client/gw_ping.jl")
    include("Client/gw_pull.jl")
    include("Client/gw_reset_server.jl")
    include("Client/gw_clear_rts.jl")
    include("Client/setup_gitworker.jl")
    include("Client/gw_send_killsig.jl")

    export setup_gitworker, 
        gw_spawn, 
        gw_push, gw_ping, gw_pull, 
        gw_reset_server, gw_clear_rts, gw_send_killsig

    include("ExternalCmds/utils.jl")
    
    include("Core/utils.jl")
    include("Core/config.jl")
    include("Core/gen_id.jl")
    include("Core/sys_globals.jl")
    include("Core/repo_update.jl")
    include("Core/sync_script.jl")
    include("Core/nuke_script.jl")
    include("Core/reset_server.jl")
    
    include("Signals/procs.jl")
    include("Signals/utils.jl")
    include("Signals/killsig.jl")
    include("Signals/resetsig.jl")

    include("Tasks/long_task_os.jl")
    include("Tasks/long_tasks.jl")
    include("Tasks/set_long_task.jl")
    include("Tasks/spawn_long_task.jl")
    include("Tasks/task_logs.jl")
    include("Tasks/utils.jl")
    
    include("FileSystem/utils.jl")
    include("FileSystem/dirs.jl")
    include("FileSystem/filter_gitwr.jl")
    
    include("Server/procs.jl")
    include("Server/atexit.jl")
    include("Server/run_gitworker_server.jl")
    include("Server/server_loop.jl")
    include("Server/loopcontrol.jl")
    include("Server/upload_data.jl")
    include("Server/exec_signals.jl")
    include("Server/download_data.jl")
    include("Server/sys_maintinance.jl")
    include("Server/repo_maintinance.jl")
    include("Server/server_loop_os.jl")

    export run_gitworker_server
    
    include("Events/FileTracker.jl")
    include("Events/waitfor.jl")
    
    include("Test/test_repos.jl")
    include("Test/monkey_delete.jl")
    include("Test/create_test_engine.jl")

    function __init__()
        !Sys.isunix() && error("Non-unix system are not yet supported!")
    end
    
end
