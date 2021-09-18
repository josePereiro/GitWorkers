_keepout_git(path) = basname(path) == ".git"

filter_gitsh(f::Function; keepout = _keepout_git, kwargs...) = filterdown(f, _gitsh_urldir(); keepout, kwargs...)