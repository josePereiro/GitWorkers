"""
    Create a file and all the path necessary to it
"""
function create_file(file)
    ispath(file) && return nothing
    mkpath(file |> dirname)
    touch(file)
end