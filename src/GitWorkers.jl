module GitWorkers

    function __init__()
        !Sys.isunix() && error("Non-unix systems are not yet supported!")
        
        # set global logger
        _set_global_logger()
    end
    
end
