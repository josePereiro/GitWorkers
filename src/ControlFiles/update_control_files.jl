
"""
    update worker ORIGIN_CONFIG dictionary
"""
function update_origin_config(path = pwd())

    # TODO: Log this
    try
        ORIGIN_CONFIG = read_origin_config(path)
    catch err
        write_origin_config(ORIGIN_CONFIG, path; create = true)
    end

end

"""
    update worker LOCAL_STATUS dictionary
"""
function update_local_status(path = pwd())

    # TODO: Log this
    try
        LOCAL_CONFIG = read_local_status(path)
    catch err
        write_local_status(ORIGIN_CONFIG, path; create = true)
    end

end