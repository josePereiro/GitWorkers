# Tests at file://./../../test/UtilsTests/find_down_tests.jl
# Tests at file://./../../test/UtilsTests/find_up_tests.jl
"""
    Create a file and all the path necessary to it
"""
function create_file(file)
    ispath(file) && return nothing
    mkpath(file |> dirname)
    touch(file)
end