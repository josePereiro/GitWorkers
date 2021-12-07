module GitWorkers

    using GitLinks
    
    import Dates
    import Dates: now
    import Pkg
    
    import TOML
    import Serialization: serialize, deserialize

    import Logging
    import Logging: ConsoleLogger, global_logger, with_logger
    import LoggingExtras
    import LoggingExtras: TeeLogger, DatetimeRotatingFileLogger

    # Type (Order matters)
    include("AbstractWorkers/AbstractWorker.jl")
    include("Worker/GitWorker.jl")
    include("Tasks/GWTask.jl")

    # Workers
    include("AbstractWorkers/tree_struct.jl")
    include("AbstractWorkers/procs_admin.jl")
    include("AbstractWorkers/logging.jl")
    
    include("Deamon/GWDeamon.jl")
    include("Deamon/procs_reg.jl")
    include("Deamon/tree_struct.jl")
    include("Deamon/run_server.jl")

    include("Worker/worker.jl")
    include("Worker/gitlink_proc.jl")
    include("Worker/tasks_admin_proc.jl")
    include("Worker/procs_reg.jl")
    include("Worker/tree_struct.jl")

    include("Tasks/gwt_env.jl")
    include("Tasks/out_log.jl")
    include("Tasks/parse_args.jl")
    include("Tasks/readme.jl")
    include("Tasks/runme.jl")
    include("Tasks/task_toml.jl")
    include("Tasks/taskos.jl")
    include("Tasks/taskdat.jl")
    include("Tasks/taskid.jl")
    include("Tasks/utils.jl")
    include("Tasks/tree_struct.jl")
    include("Tasks/write_task.jl")
    include("Tasks/spawn_task.jl")
    
    # Utils
    include("Utils/FileTracker.jl")
    include("Utils/rand_str.jl")
    include("Utils/toml_utils.jl")
    include("Utils/run.jl")
    include("Utils/flush_all.jl")
    include("Utils/logging.jl")
    include("Utils/hash_file.jl")
    include("Utils/printerr.jl")
    include("Utils/procs.jl")
    include("Utils/fileutils.jl")
    include("Utils/dictutils.jl")
    include("Utils/julia_cmd.jl")
    include("Utils/nusv_file.jl")
    include("Utils/base.jl")

    include("Client/upload_task.jl")
    include("Client/gw_setup.jl")
    include("Client/gw_curr.jl")
    include("Client/gw_ping.jl")
    include("Client/gw_spawn.jl")
    
    # DevLand
    include("DevLand/gw_create_devland.jl")
    include("DevLand/test_gw.jl")
    include("DevLand/tree_struct.jl")

    export gw_setup, gw_curr, gw_ping
    export run_gitworker_server
    export gw_create_devland
    export @gw_spawn
    
    function __init__()
        !Sys.isunix() && error("Non-unix systems are not yet supported!")

        _set_global_logger()
    end
    
end
