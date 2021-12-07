_mkdir(path) = mkpath(dirname(path))

_readdir(dir; join::Bool = false, sort::Bool = true) = 
    try; readdir(dir; join, sort) catch err; String[] end 

function _readdir(f::Function, dir; kwargs...)
    for file in _readdir(dir; kwargs...)
        f(file)
    end
end

function _rm(path)
    try; rm(path; recursive = true, force = true)
    catch err; end
end

function _foldersize(dir)
    size = 0
    for (root, _, files) in walkdir(dir)
        size += sum(filesize.(joinpath.(root, files)))
    end
    return size
end

function _cp(src::AbstractString, dst::AbstractString)
    try; cp(src, dst; force = true)
    catch err; end
end

# get the rel path from basename(startpath)
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