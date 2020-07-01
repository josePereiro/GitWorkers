"""
    returns true if the subpath has dir as one
    of its parents
"""
function is_subpath(subpath, dir)
    subpath, dir = (subpath, dir) .|> abspath
    !ispath(subpath) || !isdir(dir) && return false
    return startswith(subpath, dir)
end