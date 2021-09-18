module GitWorkers
    
    using FilesTreeTools
    import LibGit2
    using Dates
    using Serialization
    import TOML

    include("ExternalCmds/run_cmd.jl")
    include("ExternalCmds/force_kill.jl")
    include("ExternalCmds/julia.jl")

    include("Core/config.jl")
    include("Core/sys_globals.jl")
    include("Core/sync.jl")
    include("Core/locks.jl")
    include("Core/gen_id.jl")

    include("FileSystem/gitwr_dirs.jl")
    include("FileSystem/filter_gitwr.jl")
    
    include("Client/setup_gitworker.jl")
    include("Client/gitworker.jl")
    
    include("Server/run_server.jl")
    
    include("Maintenance/gitignore.jl")
    
    # include("Tasks/curr_cmd.jl")
    # include("Tasks/exec_cmd.jl")
    # include("Tasks/gitwr_cmd.jl")
    
    include("Events/FileTracker.jl")
    
    include("Test/test_repos.jl")
    include("Test/monkey_delete.jl")
    include("Test/create_test_engine.jl")
    
    
end
