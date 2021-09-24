const _GITWR_SYSFILES_DIR = ".sysfiles"

# ------------------------------------------------------
# ITER FREC
const _GITWR_MIN_CURRITER = 1
const _GITWR_MAX_CURRITER = typemax(Int)

_curriter_sysfile() = _repodir(_GITWR_SYSFILES_DIR, ".curriter")

function _set_curriter(ptime::Real = _GITWR_MIN_CURRITER)
    ptime = clamp(round(Int, ptime), _GITWR_MIN_CURRITER, _GITWR_MAX_CURRITER)
    fn = _curriter_sysfile()
    write(fn, string(ptime))
    return ptime
end

function _get_curriter()
    fn = _curriter_sysfile()
    !isfile(fn) && _set_curriter()
    pf = tryparse(Int, read(fn, String))
    return isnothing(pf) ? _set_curriter() : clamp(pf, _GITWR_MIN_CURRITER, _GITWR_MAX_CURRITER)
end

# ------------------------------------------------------
# ITER FREC
const _GITWR_MIN_ITERFREC = 1.0
const _GITWR_MAX_ITERFREC = 3600.0
const _GITWR_DEFLT_ITERFREC = 25.0
const _GITWR_ITER_FRACWT = 3.0

_iterfrec_sysfile() = _repodir(_GITWR_SYSFILES_DIR, ".iterfrec")

function _set_iterfrec(ptime::Real = _GITWR_DEFLT_ITERFREC)
    ptime = clamp(float(ptime), _GITWR_MIN_ITERFREC, _GITWR_MAX_ITERFREC)
    fn = _iterfrec_sysfile()
    write(fn, string(ptime))
    return ptime
end

function _get_iterfrec()
    fn = _iterfrec_sysfile()
    !isfile(fn) && _set_iterfrec()
    pf = tryparse(Float64, read(fn, String))
    return isnothing(pf) ? _set_iterfrec() : clamp(pf, _GITWR_MIN_ITERFREC, _GITWR_MAX_ITERFREC)
end

# ------------------------------------------------------
_pushflag_sysfile() = _repodir(_GITWR_SYSFILES_DIR, ".pushflag")


_set_pushflag() = touch(_pushflag_sysfile())

function _check_pushflag() 
    fn = _pushflag_sysfile()
    flag = isfile(fn)
    flag && _gwrm(fn)
    return flag
end