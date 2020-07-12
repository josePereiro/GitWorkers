# Tests at file://./../../test/UtilsTests/find_down_tests.jl
# Tests at file://./../../test/UtilsTests/find_up_tests.jl
"""
    Create a file and all the path necessary for it.
    Returns an abspath
"""
function create_file(file)
    file = file |> abspath
    ispath(file) && return file
    mkpath(file |> dirname)
    touch(file) 
end