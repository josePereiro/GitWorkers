# A worker is a folder with an origin-config file
# test st file://./../../test/prepare_tests.jl#55s

is_origin_config_file(path) = isfile(path) && is_inrepo(path) && basename(path) == ORIGIN_CONFIG_FILE_NAME

function read_origin_config(path = pwd())


end

