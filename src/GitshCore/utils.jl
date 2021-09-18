function _cp(src::AbstractString, dst::AbstractString)
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    cp(src, dst; force = true)
end