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
_gitwr_rootdir(rootdir::String = _get_root()) = rootdir

# ---------------------------------------------------------------
const _gitwr_HOMEDIR_NAME = ".gitworker"

function _gitwr_homedir(rootdir::String = _gitwr_rootdir())
    home = joinpath(rootdir, _gitwr_HOMEDIR_NAME)
    !isdir(home) && mkpath(home)
    return abspath(home)
end

# ---------------------------------------------------------------
function _gitwr_urldir(homedir::String, url::String)
    url = replace(url, r"[^a-zA-Z0-9-_\\.]"=> "_")
    urldir = joinpath(homedir, url)
    !isdir(urldir) && mkpath(urldir)
    return urldir
end

_gitwr_urldir() = _gitwr_urldir(_gitwr_homedir(), _get_url())

# ---------------------------------------------------------------
const _gitwr_TEMPDIR_NAME = "$(_gitwr_HOMEDIR_NAME)_temp"

function _gitwr_tempdir(urldir::String = _gitwr_urldir()) 
    dir = joinpath(urldir, _gitwr_TEMPDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end

function _tempfile(urldir = _gitwr_urldir())
    while true
        file = joinpath(_gitwr_tempdir(urldir), _gen_id())
        !isfile(file) && return file
    end
end

function _ls_gitwr_tempdir(urldir::String = _gitwr_urldir())
    dir = _gitwr_tempdir(urldir)
    isdir(dir) ? readdir(dir) : String[]
end

# ---------------------------------------------------------------
const _gitwr_LOCALDIR_NAME = "$(_gitwr_HOMEDIR_NAME)_local"

function _gitwr_localdir(urldir::String = _gitwr_urldir()) 
    dir = joinpath(urldir, _gitwr_LOCALDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end

# ---------------------------------------------------------------
const _gitwr_STAGEDIR_NAME = "$(_gitwr_HOMEDIR_NAME)_stage"

function _gitwr_stagedir(urldir::String = _gitwr_urldir()) 
    dir = joinpath(urldir, _gitwr_STAGEDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
