# ---------------------------------------------------------------
gitworkers_structure() = 
""""
sys_root (root)
    |------- .gitworkers (home)
    |        |------- .gitworker-deamon
    |        |        |------ deamon.toml
    |        |        |------ .deamon-logs
    |        |        |         |------ log1                
    |        |        |
    |        |        .
    |        |        .
    |        |        .
    |        |
    |        |------- urldir 1                                  
    |        |        |------ Project.toml                            
    |        |        |------ Manifest.toml                            
    |        |        |------ .local                            
    |        |        |         |------ local.config                    
    |        |        |         |------ .tasks.cmds (mv from repo, transcient)
    |        |        |         |         |------ cmd1
    |        |        |         |         |------ cmd2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |
    |        |        |         |------ .tasks.expr (transcient)
    |        |        |         |         |------ cmd1
    |        |        |         |         |------ cmd2
    |        |        |         |         |
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |         .
    |        |        |         |
    |        |        |         |------ .tasks.outs (merge to repo, persistant)
    |        |        |         |         |------ out1
    |        |        |         |         |------ out2
    |        |        |         |         |
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |         . 
    |        |        |         |
    |        |        |         |------ .signals (mv from repo, transcient)
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
    |        |        |         |------ .tasks.outs (cp from local, persistant)
    |        |        |         |         |------ out1
    |        |        |         |         |------ out2
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
_gw_rootdir(ns...) = _mkdirpath(abspath(_get_root()), ns...)

# ---------------------------------------------------------------
# the home of GitWorkers
_gitworkers_homedir(ns...) = _gw_rootdir(".gitworkers", ns...)

# ---------------------------------------------------------------
# the root of the repo
_format_url(url) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
_urldir(ns...) = _gitworkers_homedir(_format_url(_get_url()), ns...)
_rel_urlpath(path) = _relbasepath(path, _urldir())
_native_urlpath(path) = _urldir(_rel_urlpath(path))

# ---------------------------------------------------------------
# deamon
_deamondir(ns...) = _gitworkers_homedir(".gitworker-deamon", ns...)
_deamon_procs_dir(ns...) = _deamondir(".deamon-procs", ns...)
_deamon_logs_dir(ns...) = _deamondir(".deamon-logs", ns...)

# ---------------------------------------------------------------
# gitworkers
_localdir(ns...) = _urldir(".local", ns...)
_localver(path) = _mkdirpath(replace(path, _repodir() => _localdir()))
_repodir(ns...) = _urldir(".repo", ns...)
_repover(path) = _mkdirpath(replace(path, _localdir() => _repodir()))

for (_funname, _dirname) in [
        # sys logs
        (:server_deamon_logs_dir, ".server-deamon-logs"), 
        (:server_main_logs_dir, ".server-main-logs"), 
        (:server_loop_logs_dir, ".server-loop-logs"), 

        # tasks
        (:tasks_cmds_dir , ".tasks-cmds"),
        (:tasks_exprs_dir, ".tasks-exprs"),
        (:tasks_outs_dir, ".tasks-outs"),
        
        # process
        (:procs_dir, ".procs"),
        # (:tasks_procs_dir, ".tasks-procs"),
        # (:tasks_main_dir, ".server-main-proc"),
        # (:tasks_loop_dir, ".server-loop-proc"),

        # data
        (:date_dir, ".data"),
        
        # signals
        (:signals_dir, ".signals"),

        # loopcontrol
        (:loop_control_dir, ".loop-control")
    ]

    _local_funname = Symbol("_local_", _funname)
    @eval $(_local_funname)() = _mkpath(_localdir($(_dirname)))
    @eval $(_local_funname)(n, ns...) = _localdir($(_dirname), n, ns...)
    _repo_funname = Symbol("_repo_", _funname)
    @eval $(_repo_funname)() = _mkpath(_repodir($(_dirname)))
    @eval $(_repo_funname)(n, ns...) = _repodir($(_dirname), n, ns...)
end
