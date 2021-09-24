function _relbasepath(path, startpath)
	stoppath = basename(startpath)
	!contains(path, stoppath) && return ""

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

function _gwrm(path)
    path = _local_urlpath(path)
    !ispath(path) && return
    try; rm(path; recursive = true, force = true)
        catch err; end
end

function _gwcp(src::AbstractString, dst::AbstractString)
    src = _local_urlpath(src)
    dst = _local_urlpath(dst)
    !ispath(src) && return
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    cp(src, dst; force = true)
end

function _gwmv(src::AbstractString, dst::AbstractString)
    src = _local_urlpath(src)
    dst = _local_urlpath(dst)
    !ispath(src) && return
    dstdir = dirname(dst)
    !isdir(dstdir) && makedir(dstdir)
    mv(src, dst; force = true)
end