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

function _mkpath(n, ns...)
    path = joinpath(string(n), string.(ns)...)
    dir = dirname(path)
    !isdir(dir) && mkpath(dir)
    return path
end