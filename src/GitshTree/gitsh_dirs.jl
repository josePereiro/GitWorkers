# ---------------------------------------------------------------
dir_structure() = 
""""
sys_root
    |------- gitsh_home (.gitsh)
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
_gitsh_rootdir(rootdir::String = _get_root()) = rootdir

# ---------------------------------------------------------------
const _GITSH_HOMEDIR_NAME = ".gitsh"

function _gitsh_homedir(rootdir::String = _gitsh_rootdir())
    home = joinpath(rootdir, _GITSH_HOMEDIR_NAME)
    !isdir(home) && mkpath(home)
    return abspath(home)
end

# ---------------------------------------------------------------
function _gitsh_urldir(homedir::String, url::String)
    url = replace(url, r"[^a-zA-Z0-9-_\\.]"=> "_")
    urldir = joinpath(homedir, url)
    !isdir(urldir) && mkpath(urldir)
    return urldir
end

_gitsh_urldir() = _gitsh_urldir(_gitsh_homedir(), _get_url())

# ---------------------------------------------------------------
const _GITSH_TEMPDIR_NAME = "$(_GITSH_HOMEDIR_NAME)_temp"

function _gitsh_tempdir(urldir::String = _gitsh_urldir()) 
    dir = joinpath(urldir, _GITSH_TEMPDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end

function _tempfile(urldir = _gitsh_urldir())
    while true
        file = joinpath(_gitsh_tempdir(urldir), _gen_id())
        !isfile(file) && return file
    end
end

function _ls_gitsh_tempdir(urldir::String = _gitsh_urldir())
    dir = _gitsh_tempdir(urldir)
    isdir(dir) ? readdir(dir) : String[]
end

# ---------------------------------------------------------------
const _GITSH_LOCALDIR_NAME = "$(_GITSH_HOMEDIR_NAME)_local"

function _gitsh_localdir(urldir::String = _gitsh_urldir()) 
    dir = joinpath(urldir, _GITSH_LOCALDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end

# ---------------------------------------------------------------
const _GITSH_STAGEDIR_NAME = "$(_GITSH_HOMEDIR_NAME)_stage"

function _gitsh_stagedir(urldir::String = _gitsh_urldir()) 
    dir = joinpath(urldir, _GITSH_STAGEDIR_NAME)
    !isdir(dir) && mkpath(dir)
    return dir
end
