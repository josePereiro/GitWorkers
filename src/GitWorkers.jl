module GitWorkers

    import GitLinks
    import GitLinks: GitLink

    include("Types/GitWorker.jl")
    
    include("Utils/expr_src.jl")

    include("TreeStruct/tree_struct.jl")
    include("TreeStruct/utils.jl")

    include("GitLink/gitlink.jl")

    include("Client/gw_setup.jl")
    include("Client/gw_curr.jl")
    include("Client/gw_ping.jl")
    
    include("DevLand/gw_create_devland.jl")

    export gw_setup, gw_curr, gw_ping
    


    function __init__()
        !Sys.isunix() && error("Non-unix systems are not yet supported!")
    end
    
end
