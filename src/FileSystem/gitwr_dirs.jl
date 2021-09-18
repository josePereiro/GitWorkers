# ---------------------------------------------------------------
dir_structure() = 
""""
sys_root
    |------- gitwr_home (.gitworker)
    |        |------- url_dir 1
    |        |        |------ .git
    |        |        |------ .local
    |        |        |------ .stage
    |        |        |
    |        |        |
    .        .        .
    .        .        .
    .        .        .
"""

# ---------------------------------------------------------------
_gitwr_rootdir() = abspath(_get_root())

# ---------------------------------------------------------------
const _GITWR_HOMEDIR_NAME = ".gitworker"

function _gitwr_homedir()
    homedir = joinpath(_gitwr_rootdir(), _GITWR_HOMEDIR_NAME)
    !isdir(homedir) && mkpath(homedir)
    return homedir
end

_gitwr_homedir(n, ns...) = joinpath(_gitwr_homedir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
_format_url(url) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")

function _gitwr_urldir()
    urldir = _gitwr_homedir(_format_url(_get_url()))
    !isdir(urldir) && mkpath(urldir)
    return urldir
end

_gitwr_urldir(n, ns...) = joinpath(_gitwr_urldir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
const _GITWR_TEMPDIR_NAME = "$(_GITWR_HOMEDIR_NAME)_temp"

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

function _ls_gitwr_tempdir()
    dir = _gitwr_tempdir()
    println.(isdir(dir) ? readdir(dir) : String[])
    return nothing
end

# ---------------------------------------------------------------
const _GITWR_LOCALDIR_NAME = "$(_GITWR_HOMEDIR_NAME)_local"

function _gitwr_localdir() 
    dir = _gitwr_urldir(_GITWR_LOCALDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_localdir(n, ns...) = joinpath(_gitwr_localdir(), string(n), string.(ns)...)

# ---------------------------------------------------------------
const _GITWR_STAGEDIR_NAME = "$(_GITWR_HOMEDIR_NAME)_stage"

function _gitwr_stagedir() 
    dir = _gitwr_urldir(_GITWR_STAGEDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
_gitwr_stagedir(n, ns...) = joinpath(_gitwr_stagedir(), string(n), string.(ns)...)