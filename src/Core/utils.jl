function _cp(src::AbstractString, dst::AbstractString)
    !isfile(src) && return
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    cp(src, dst; force = true)
end