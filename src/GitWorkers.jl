module GitWorkers
    
    import LibGit2
    import TOML
    import ArgParse
    import Pkg

    using FilesTreeTools
    using Dates
    using Serialization

    include("ExternalCmds/run_cmd.jl")
    include("ExternalCmds/julia.jl")
    include("ExternalCmds/utils.jl")

    include("Core/config.jl")
    include("Core/sys_globals.jl")
    include("Core/repo_update.jl")
    include("Core/sync_script.jl")
    include("Core/gen_id.jl")
    include("Core/utils.jl")
    include("Core/reset_server.jl")
    
    include("SysFiles/killsig.jl")
    include("SysFiles/procs.jl")
    include("SysFiles/pushflag.jl")
    include("SysFiles/resetsig.jl")
    include("SysFiles/standby.jl")
    include("SysFiles/utils.jl")

    include("Routines/routines.jl")
    include("Routines/eval.jl")
    include("Routines/routines_templates.jl")
    include("Routines/utils.jl")
    
    include("FileSystem/gitwr_dirs.jl")
    include("FileSystem/filter_gitwr.jl")
    include("FileSystem/utils.jl")
    
    include("Client/setup_gitworker.jl")
    include("Client/gwspawn.jl")
    include("Client/gw_push.jl")
    include("Client/gw_ping.jl")
    include("Client/waitfor.jl")
    include("Client/gw_send_killsig.jl")
    include("Client/gw_pull.jl")
    include("Client/gw_reset.jl")
    include("Client/gw_clear_rts.jl")
    include("Client/gw_set_iterfrec.jl")
    include("Client/gw_send_standby.jl")
    
    include("Server/run_server.jl")
    include("Server/signal_register.jl")
    include("Server/server_loop.jl")
    include("Server/exit.jl")
    include("Server/sync_task_data.jl")
    include("Server/loopcontrol.jl")
    
    include("Events/FileTracker.jl")
    
    include("Test/test_repos.jl")
    include("Test/monkey_delete.jl")
    include("Test/create_test_engine.jl")

    function __init__()
        !Sys.isunix() && error("Non-unix system are not yet supported!")
    end
    
end
