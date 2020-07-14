# A worker is a folder with an origin-config file
# Tests at file://./../../test/ControlFilesTests/control_files_tests.jl

build_local_status_file(workerroot) = joinpath(workerroot, LOCAL_STATUS_FILE_NAME)

is_local_status_file(path) = path |> isfile && path |> basename == LOCAL_STATUS_FILE_NAME && path |> dirname |> is_workerroot


"""

"""
function read_status(path = pwd(); onerr = CONTROL_DICT_TYPE())
    workerroot = path |> find_ownerworker |> get_workerroot
    local_status_file = build_local_status_file(workerroot)
    try 
        return read_json(local_status_file) 
    catch err
        return onerr
    end
end
    
"""

"""
function write_status(path = pwd(); create = true)
    workerroot = path |> find_ownerworker |> get_workerroot
    local_status_file = build_local_status_file(workerroot)
    create && create_file(local_status_file)
    return write_json(local_status_file, LOCAL_STATUS)
end
