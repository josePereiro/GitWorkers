"""

"""
function find_local_status_file(path = pwd(); allow_missing = false)
    local_status_file = findup_worker(is_local_status_file, path)
    !allow_missing && isnothing(local_status_file) && error("$(LOCAL_STATUS_FILE_NAME) not found!!!")
    return local_status_file
end

"""

"""
function find_origin_config_file(path = pwd(); allow_missing = false)
    origin_config_file = findup_worker(is_origin_config_file, path)
    !allow_missing && isnothing(origin_config_file) && error("$(ORIGIN_CONFIG_FILE_NAME) not found!!!")
    return origin_config_file
end

