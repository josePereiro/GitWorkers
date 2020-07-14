# A worker is a folder with an origin-config file
# Tests at file://./../../test/ControlFilesTests/control_files_tests.jl

build_origin_config_file(workerroot) = joinpath(workerroot, ORIGIN_CONFIG_FILE_NAME)

is_origin_config_file(path) = isfile(path) && is_workerroot(path |> dirname) && basename(path) == ORIGIN_CONFIG_FILE_NAME


"""

"""
function read_config(path = pwd(); onerr = CONTROL_DICT_TYPE())
    workerroot = path |> find_ownerworker |> get_workerroot
    origin_config_file = build_origin_config_file(workerroot)
    try 
        return read_json(origin_config_file) 
    catch err
        return onerr
    end
end

"""

"""
function write_config(path = pwd(); create = true)
    workerroot = path |> find_ownerworker |> get_workerroot
    origin_config_file = build_origin_config_file(workerroot)
    create && create_file(origin_config_file)
    return write_json(origin_config_file, ORIGIN_CONFIG)
end

