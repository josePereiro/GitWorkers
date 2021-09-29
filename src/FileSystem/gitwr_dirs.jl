# ---------------------------------------------------------------
gitworkers_structure() = 
""""
sys_root (root)
    |------- .gitworkers (home)
    |        |------- urldir 1                                  
    |        |        |------ Project.toml                            
    |        |        |------ Manifest.toml                            
    |        |        |------ .local                            
    |        |        |         |------ local.config                    
    |        |        |         |------ .logs (cp to repo, persistant)
    |        |        |         |         |------ log1
    |        |        |         |         |------ log2
    |        |        |         |         |
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |
    |        |        |         |------ .signals (mv from repo, transcient)
    |        |        |         |
    |        |        |         |------ .tasks (mv from repo, transcient)
    |        |        |         |         |------ task1
    |        |        |         |         |------ task2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |
    |        |        |         |------ .data (save_mv to repo, transcient)
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
    |        |        |         |------ .logs (cp from local, persistant)
    |        |        |         |         |------ log1
    |        |        |         |         |------ log2
    |        |        |         |         |
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |
    |        |        |         |------ .procs (persistant)
    |        |        |         |         |------ id.server.proc
    |        |        |         |         |------ id1.task.proc
    |        |        |         |         |------ id2.task.proc
    |        |        |         |         |
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |
    |        |        |         |------ .tasks (mv to local, transcient)
    |        |        |         |         |------ task1
    |        |        |         |         |------ task2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |
    |        |        |         |------ .data (save_mv from local, transcient)
    |        |        |         |         |------ bloob1
    |        |        |         |         |------ bloob2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .  
    |        |        |         |
    |        |        |         |------ .loopcontrol (persistant)
    |        |        |         |         |------ iterfrec
    |        |        |         |         |------ curriter
    |        |        |         |         |------ pushflag (transcient)
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
_native_urlpath(path) = _urldir(_rel_urlpath(path))

# ---------------------------------------------------------------
_localdir(ns...) = _urldir(".local", ns...)
_localver(path) = _mkpath(replace(path, _repodir() => _localdir()))
_local_logsdir(ns...) = _localdir(".logs", ns...)
_local_sigdir(ns...) = _localdir(".signals", ns...)
_local_tasksdir(ns...) = _localdir(".tasks", ns...)
_local_datadir(ns...) = _localdir(".data", ns...)

_repodir(ns...) = _urldir(".repo", ns...)
_repover(path) = _mkpath(replace(path, _localdir() => _repodir()))
_repo_logsdir(ns...) = _repodir(".logs", ns...)
_repo_sigdir(ns...) = _repodir(".signals", ns...)
_repo_procsdir(ns...) = _repodir(".procs", ns...)
_repo_tasksdir(ns...) = _repodir(".tasks", ns...)
_repo_datadir(ns...) = _repodir(".data", ns...)
_repo_loopcontroldir(ns...) = _repodir(".loopcontrol", ns...)