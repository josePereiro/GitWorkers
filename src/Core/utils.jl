function _cp(src::AbstractString, dst::AbstractString)
    !isfile(src) && return
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    cp(src, dst; force = true)
end

_create_dummy() = write(_gitwr_stagedir(".gitworker.dummy"), _gen_id())