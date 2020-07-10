# A worker is a folder with an origin-config file
# test st file://./../../test/prepare_tests.jl#55s

is_local_status_file(path) = isfile(path) && is_inrepo(path |> dirname) && basename(path) == LOCAL_STATUS_FILE_NAME

build_local_status_file(workerroot) = joinpath(workerroot, LOCAL_STATUS_FILE_NAME)

"""

"""
function read_local_status(path = pwd())
    local_status_file = find_local_status_file(path, allow_missing = false)
    return read_json(local_status_file)
end

"""

"""
function write_local_status(dict::Dict = ORIGIN_CONFIG, path = pwd(); create = true)
    local_status_file = find_local_status_file(path, allow_missing = create)
    if create && isnothing(local_status_file)
        ownerroot = find_ownerworker(path) |> get_workerroot
        local_status_file = build_local_status_file(ownerroot)
        create_file(local_status_file)
    end
    return write_json(local_status_file, dict)
end
