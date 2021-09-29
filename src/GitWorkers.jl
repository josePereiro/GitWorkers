module GitWorkers
    
    import LibGit2
    import TOML
    # import ArgParse
    import Pkg

    using FilesTreeTools
    using Dates
    using Serialization
    import ExternalCmds

    include("ExternalCmds/utils.jl")
    
    include("Core/utils.jl")
    include("Core/config.jl")
    include("Core/gen_id.jl")
    include("Core/sys_globals.jl")
    include("Core/repo_update.jl")
    include("Core/sync_script.jl")
    include("Core/reset_server.jl")
    
    include("Signals/procs.jl")
    include("Signals/utils.jl")
    include("Signals/killsig.jl")
    include("Signals/standby.jl")
    include("Signals/pushflag.jl")
    include("Signals/resetsig.jl")

    include("Tasks/utils.jl")
    include("Tasks/routines.jl")
    include("Tasks/task_logs.jl")
    include("Tasks/spawn_long_task.jl")
    include("Tasks/routines_templates.jl")
    
    include("FileSystem/utils.jl")
    include("FileSystem/gitwr_dirs.jl")
    include("FileSystem/filter_gitwr.jl")
    
    include("Client/gwspawn.jl")
    include("Client/gw_push.jl")
    include("Client/gw_ping.jl")
    include("Client/waitfor.jl")
    include("Client/gw_pull.jl")
    include("Client/gw_reset.jl")
    include("Client/gw_clear_rts.jl")
    include("Client/setup_gitworker.jl")
    include("Client/gw_send_killsig.jl")
    include("Client/gw_send_standby.jl")
    
    include("Server/procs.jl")
    include("Server/atexit.jl")
    include("Server/run_server.jl")
    include("Server/server_loop.jl")
    include("Server/loopcontrol.jl")
    include("Server/upload_data.jl")
    include("Server/exec_signals.jl")
    include("Server/download_data.jl")
    include("Server/signal_register.jl")
    include("Server/spawn_long_task.jl")
    include("Server/sys_maintinance.jl")
    include("Server/repo_maintinance.jl")
    
    include("Events/FileTracker.jl")
    
    include("Test/test_repos.jl")
    include("Test/monkey_delete.jl")
    include("Test/create_test_engine.jl")

    function __init__()
        !Sys.isunix() && error("Non-unix system are not yet supported!")
    end
    
end
