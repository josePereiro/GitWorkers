"""
    update_config(config::Dict) = merge!(CONFIG, config)
"""
update_config(config::Dict) = merge!(CONFIG, config)


"""
    Update the config field in many workers
"""
update_config(config::Dict, workers::Vector) = foreach(workers) do w 
    remotecall_wait(update_config, w, config)
end

