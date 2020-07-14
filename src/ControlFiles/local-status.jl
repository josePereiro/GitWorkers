# A worker is a folder with an origin-config file
# Tests at file://./../../test/ControlFilesTests/control_files_tests.jl

build_local_status_file(workerroot) = joinpath(workerroot, LOCAL_STATUS_FILE_NAME)

is_local_status_file(path) = path |> isfile && path |> basename == LOCAL_STATUS_FILE_NAME && path |> dirname |> is_workerroot


"""

"""
function read_status(path = pwd(); onmissing = Dict())
    local_status_file = find_local_status_file(path, allow_missing = false)
    try
        return read_json(local_status_file)
    catch err
        return onmissing
    end
end
    
"""

"""
function write_status(dict::Dict = ORIGIN_CONFIG, path = pwd(); create = true)
    local_status_file = find_local_status_file(path, allow_missing = create)
    if create && isnothing(local_status_file)
        ownerroot = find_ownerworker(path) |> get_workerroot
        local_status_file = build_local_status_file(ownerroot)
        create_file(local_status_file)
    end
    return write_json(local_status_file, dict)
end
