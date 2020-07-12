# A worker is a folder with an origin-config file
# Tests at file://./../../test/ControlFilesTests/control_files_tests.jl

build_local_status_file(workerroot) = joinpath(workerroot, LOCAL_STATUS_FILE_NAME)

is_local_status_file(path) = path |> isfile && path |> basename == LOCAL_STATUS_FILE_NAME && path |> dirname |> is_workerroot


"""

"""
read_local_status(path = pwd()) = 
    find_local_status_file(path, allow_missing = false) |> read_json

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

function merge_local_status_files(path = pwd())
    worker = find_ownerworker(path)
    workerroot = worker |> get_workerroot
    local_status_file = build_local_status_file(workerroot)
    local_status_copy_file = build_local_status_copy_file(workerroot)

    !isfile(local_status_copy_file) && return
    isfile(local_status_file) && 
        cp(local_status_copy_file, local_status_file, force = true)
end

function copy_local_status_file(path = pwd())
    worker = find_ownerworker(path)
    workerroot = worker |> get_workerroot
    local_status_file = build_local_status_file(workerroot)
    local_status_copy_file = build_local_status_copy_file(workerroot)

    !isfile(local_status_file) && return
    isfile(local_status_copy_file) && 
        cp(local_status_file, local_status_copy_file, force = true)
end