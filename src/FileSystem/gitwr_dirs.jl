# ---------------------------------------------------------------
gitworkers_structure() = 
""""
sys_root                                                        
    |------- .gitworkers                                        
    |        |------- urldir 1                                  
    |        |        |------ .local                            
    |        |        |         |------ local.config
    |        |        |         |------ .tasks                  
    |        |        |         |           |------ .exprs      
    |        |        |         |           |------ .logs       
    |        |        |         |           |                   
    |        |        |         |
    |        |        |         |
    |        |        |         |------ .sys                  
    |        |        |         |
    |        |        |         |
    |        |        |         .
    |        |        |         .
    |        |        |         .
    |        |        |
    |        |        |------ .global
    |        |        |         |------ .git
    |        |        |         |------ local.config
    |        |        |         |------ .tasks                  
    |        |        |         |           |                   
    |        |        |         |           |                   
    |        |        |         |           .
    |        |        |         |           .
    |        |        |         .
    |        |        |         .
    |        |        |         .
    .        .        .
    .        .        .
    .        .        .
"""

# ---------------------------------------------------------------
# the dirpath od the home
_gitwr_rootdir() = abspath(_get_root())

# ---------------------------------------------------------------
# the home of GitWorkers
const _GITWR_HOMEDIR_NAME = ".gitworkers"

function _gitworkers_homedir()
    homedir = joinpath(_gitwr_rootdir(), _GITWR_HOMEDIR_NAME)
    !isdir(homedir) && mkpath(homedir)
    return homedir
end

_gitworkers_homedir(n, ns...) = joinpath(_gitworkers_homedir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
# the root of the repo
_format_url(url) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")

function _gitwr_urldir()
    urldir = _gitworkers_homedir(_format_url(_get_url()))
    !isdir(urldir) && mkpath(urldir)
    return urldir
end

_gitwr_urldir(n, ns...) = joinpath(_gitwr_urldir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
# transient data un-synchronized with upstream
const _GITWR_TEMPDIR_NAME = ".temp"

function _gitwr_tempdir() 
    dir = _gitwr_urldir(_GITWR_TEMPDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_tempdir(n, ns...) = joinpath(_gitwr_tempdir(), string(n), string.(ns)...)

function _gitwr_tempfile()
    while true
        file = _gitwr_tempdir(_gen_id())
        !isfile(file) && return file
    end
end

_del_gitwr_tempfiles() = rm(_gitwr_tempdir(); recursive = true, force = true)

function _ls_gitwr_tempdir()
    dir = _gitwr_tempdir()
    println.(isdir(dir) ? readdir(dir) : String[])
    return nothing
end

# ---------------------------------------------------------------
# permanent data but un-synchronized with upstream
const _GITWR_LOCALDIR_NAME = ".local"

function _gitwr_localdir() 
    dir = _gitwr_urldir(_GITWR_LOCALDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_localdir(n, ns...) = joinpath(_gitwr_localdir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
# transient data that will be pushed in the next round
const _GITWR_LOGSDIR_NAME = ".logs"
const _GITWR_LOGSDIR_GC_TIMETH =  10 * 24 * 60 * 60 # time in seconds

function _gitwr_logsdir() 
    dir = _gitwr_localdir(_GITWR_STAGEDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_logsdir(n, ns...) = joinpath(_gitwr_logsdir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
# data synchronized with upstream
const _GITWR_GLOBALDIR_NAME = ".global"

function _gitwr_globaldir() 
    dir = _gitwr_urldir(_GITWR_GLOBALDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_globaldir(n, ns...) = joinpath(_gitwr_globaldir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
# transient data that will be pushed in the next round
const _GITWR_STAGEDIR_NAME = ".stage"

function _gitwr_stagedir() 
    dir = _gitwr_urldir(_GITWR_STAGEDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_stagedir(n, ns...) = joinpath(_gitwr_stagedir(), string(n), string.(ns)...)

_del_gitwr_stagedir() = rm(_gitwr_stagedir(); recursive = true, force = true)

