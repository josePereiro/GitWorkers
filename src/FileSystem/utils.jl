function _relbasepath(path, startpath)
	stoppath = basename(startpath)

	relpath_ = ""
	leftpath = path
	while true
		leftpath, base = splitdir(leftpath)
		(base == stoppath) && break
		relpath_ = isempty(relpath_) ? base : joinpath(base, relpath_)
		(leftpath == dirname(leftpath)) && break
	end

	return relpath_
end

function _rm(path)
    try; rm(path; recursive = true, force = true)
    catch err; end
end

function _gwrm(path)
    path = _native_urlpath(path)
    !ispath(path) && return
    _rm(path)
end

function _cp(src::AbstractString, dst::AbstractString)
    try; cp(src, dst; force = true)
    catch err; end
end

function _gwcp(src::AbstractString, dst::AbstractString)
    src = _native_urlpath(src)
    dst = _native_urlpath(dst)
    !ispath(src) && return
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    cp(src, dst; force = true)
end

function _gwmv(src::AbstractString, dst::AbstractString)
    src = _native_urlpath(src)
    dst = _native_urlpath(dst)
    !ispath(src) && return
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    mv(src, dst; force = true)
end

function _gw_mvfiles(srcdir::AbstractString, dstdir::AbstractString)
    srcdir = _native_urlpath(srcdir)
    dstdir = _native_urlpath(dstdir)
    !isdir(srcdir) && return
    isfile(dstdir) && return
    !isdir(dstdir) && mkpath(dstdir)
    for file in readdir(srcdir)
        src = joinpath(srcdir, file)
        dest = joinpath(dstdir, file)
        mv(src, dest; force = true)
    end
end

"""
    copy from srcdir to dstdir whitout affecting dstdir diff files
"""
function _mergedirs(srcdir::AbstractString, dstdir::AbstractString)
    !isdir(srcdir) && return
    isfile(dstdir) && return
    !isdir(dstdir) && mkpath(dstdir)
    for name in readdir(srcdir)
        src = joinpath(srcdir, name)
        dest = joinpath(dstdir, name)
        cp(src, dest; force = true)
    end
end

"""
    copy from srcdir to dstdir whitout affecting dstdir diff files
"""
function _gw_mergedirs(srcdir::AbstractString, dstdir::AbstractString)
    srcdir = _native_urlpath(srcdir)
    dstdir = _native_urlpath(dstdir)
    _mergedirs(srcdir, dstdir)
end

"""
    force dstdir content to be equal srcdir's content
"""
function _syncdirs(srcdir::AbstractString, dstdir::AbstractString)
    !isdir(srcdir) && return
    isfile(dstdir) && return
    _rm(dstdir)
    cp(srcdir, dstdir; force = true)
end

"""
    force dstdir content to be equal srcdir's content
"""
function _gw_syncdirs(srcdir::AbstractString, dstdir::AbstractString)
    srcdir = _native_urlpath(srcdir)
    dstdir = _native_urlpath(dstdir)
    _syncdirs(srcdir, dstdir)
end

function _mkpath(n, ns...)
    path = joinpath(string(n), string.(ns)...)
    dir = dirname(path)
    !isdir(dir) && mkpath(dir)
    return path
end

_gwmkpath(n, ns...) = _native_urlpath(_mkpath(n, ns...))

_readdir(dir; join::Bool = false, sort::Bool = true) = 
    isdir(dir) ? readdir(dir; join, sort) : String[]

_gw_readdir(dir; join::Bool = false, sort::Bool = true) = 
        _readdir(_native_urlpath(dir); join, sort)

function _foldersize(dir)
    size = 0
    for (root, _, files) in walkdir(dir)
        size += sum(filesize.(joinpath.(root, files)))
    end
    return size
end

function _filterdir(f::Function, dir; join = false, sort = true)
    !isdir(dir) && String[]
    filter(f, _readdir(dir; join, sort))
end