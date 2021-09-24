# ---------------------------------------------------------------
gitworkers_structure() = 
""""
sys_root (root)
    |------- .gitworkers (home)
    |        |------- urldir 1                                  
    |        |        |------ .local                            
    |        |        |         |------ local.config                    
    |        |        |         |------ .logs
    |        |        |         |         |------ log1
    |        |        |         |         |------ log2
    |        |        |         |         |
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |
    |        |        |         |------ .data
    |        |        |         |         |------ bloob1
    |        |        |         |         |------ bloob2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         .         .
    |        |        |         .         .
    |        |        |         .
    |        |        |
    |        |        |------ .repo
    |        |        |         |------ .git
    |        |        |         |------ local.config
    |        |        |         |------ .uprepo_routines
    |        |        |         |         |------ routine1
    |        |        |         |         |------ routine2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         
    |        |        |         |------ .uplocal_routines
    |        |        |         |         |------ routine1
    |        |        |         |         |------ routine2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .  
    |        |        |         |
    |        |        |         |------ .data
    |        |        |         |         |------ bloob1
    |        |        |         |         |------ bloob2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .  
    |        |        |         |
    |        |        |         |           
    |        |        |         .           
    .        .        .         .
    |        |        .         .          
    .        .        .
    .        .        
    .                
"""

# ---------------------------------------------------------------
function _mkpath(n, ns...)
    path = joinpath(string(n), string.(ns)...)
    dir = dirname(path)
    !isdir(dir) && mkpath(dir)
    return path
end

# ---------------------------------------------------------------
# the dirpath od the home
_gitwr_rootdir(ns...) = _mkpath(abspath(_get_root()), ns...)

# ---------------------------------------------------------------
# the home of GitWorkers
_gitworkers_homedir(ns...) = _gitwr_rootdir(".gitworkers", ns...)

# ---------------------------------------------------------------
# the root of the repo
_format_url(url) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
_urldir(ns...) = _gitworkers_homedir(_format_url(_get_url()), ns...)
_rel_urlpath(path) = _relbasepath(path, _urldir())
_local_urlpath(path) = _urldir(_rel_urlpath(path))

# ---------------------------------------------------------------
_localdir(ns...) = _urldir(".local", ns...)
_localver(path) = _mkpath(replace(path, _repodir() => _localdir()))

_repodir(ns...) = _urldir(".repo", ns...)
_repover(path) = _mkpath(replace(path, _localdir() => _repodir()))
