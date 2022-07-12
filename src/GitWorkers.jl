module GitWorkers

    using GWUtils
    using GitLinks
    using GitLinks: up_push_reg!
    using FilesTreeTools
    
    import Dates
    import Dates: now
    import Pkg
    
    import TOML
    import Serialization: serialize, deserialize

    # Types (Order matters)
    include("GWAgents/types.jl")
    include("GWAgents/AbstractGWAgent.jl")
    include("GWAgents/file_struct.jl")
    include("GWAgents/GWDeamon.jl")
    include("GWAgents/GitWorker.jl")
    include("GWAgents/GWTaskRunTime.jl")

    include("Client/gw_curr.jl")
    include("Client/gw_ping.jl")
    include("Client/gw_setup.jl")
    include("Client/gw_spawn.jl")
    include("Client/gw_follow.jl")
    include("Client/gw_open_remote.jl")
    include("Client/gw_request_push.jl")
    include("Client/gw_test_task.jl")
    include("Client/gw_follow_server.jl")
    include("Client/gw_running_procs.jl")
    include("Client/gw_killem_all.jl")
    include("Client/gw_send_killer.jl")
    include("Client/upload_task.jl")
    include("Client/gw_sync.jl")
    include("Client/gw_list_tasks.jl")
    include("Client/pull_and_listen.jl")
    
    include("Server/run_server.jl")
    include("Server/spawn_worker_proc.jl")
    include("Server/spawn_task_proc.jl")
    include("Server/run_task.jl")
    include("Server/run_worker.jl")

    include("DevLand/gw_create_devland.jl")
    
    include("Utils/agents.jl")
    include("Utils/procs_admin.jl")
    include("Utils/test_utils.jl")

    export gw_create_devland
    export gw_setup, gw_ping, gw_spawn, @gw_spawn
    export gw_request_push, gw_test_task, gw_follow_server
    export gw_send_killer, gw_list_tasks,gw_running_procs
    export gw_open_remote, gw_follow
    export gw_curr, gw_curr_task
    export run_gitworker_server, gw_killem_all, gw_sync
    
    function __init__()
        !Sys.isunix() && error("Non-unix systems are not yet supported!")
    end
    
end
