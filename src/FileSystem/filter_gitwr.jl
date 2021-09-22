function _keepout_git(path) 
    basename(path) == ".git"
end

_filter_gitwr(f::Function; keepout = _keepout_git, onerr = rethrow) =
    filterdown(f, _urldir(); keepout, onerr)

_walkdown_gitwr(f::Function; keepout = _keepout_git, onerr = rethrow) = 
    walkdown(f::Function; keepout = _keepout_git, onerr = rethrow)