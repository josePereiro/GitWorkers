function _keepout_git(path) 
    basename(path) == ".git"
end

_filter_urldir(f::Function; keepout = _keepout_git, onerr = rethrow) =
    filterdown(f, _urldir(); keepout, onerr)

_filter_repodir(f::Function; keepout = _keepout_git, onerr = rethrow) =
    filterdown(f, _repodir(); keepout, onerr)

_walkdown_urldir(f::Function; keepout = _keepout_git, onerr = rethrow) = 
    walkdown(f, _urldir(); keepout, onerr)

function _findin(f::Function, dir; join = false, sort = true)
    !isdir(dir) && String[]
    filter(f, _readdir(dir; join, sort))
end