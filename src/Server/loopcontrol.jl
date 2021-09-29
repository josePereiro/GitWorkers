# ------------------------------------------------------
# ITER FREC
const _GITWR_MIN_ITERFREC = 1.0
const _GITWR_MAX_ITERFREC = 3600.0
const _GITWR_DEFLT_ITERFREC = 25.0
const _GITWR_ITER_FRACWT = 3.0

_iterfrec_file() = _repo_loopcontroldir("iterfrec")
_clamp_iterfrec(frec) = clamp(float(frec), _GITWR_MIN_ITERFREC, _GITWR_MAX_ITERFREC)

function _set_iterfrec(frec::Real = _GITWR_DEFLT_ITERFREC)
    fn = _iterfrec_file()
    frec = _clamp_iterfrec(frec)
    write(fn, string(frec))
    return frec
end

function _get_iterfrec()
    fn = _iterfrec_file()
    frec = _read_single_dat(fn, Float64, _set_iterfrec)
    return _clamp_iterfrec(frec)
end

# ------------------------------------------------------
# PUSH FLAG
_pushflag_file() = _repo_loopcontroldir("pushflag")

_set_pushflag() = touch(_pushflag_file())

function _gw_pull_and_send_pushflag(;deb = false)
    _repo_update(;deb) do
        if !isfile(_pushflag_file()) 
            _set_pushflag()
            return true
        end
        return false
    end
end

function _check_pushflag() 
    fn = _pushflag_file()
    flag = isfile(fn)
    _gwrm(fn)
    return flag
end

# ------------------------------------------------------
# ITER FREC
const _GITWR_MIN_CURRITER = 1
const _GITWR_MAX_CURRITER = typemax(Int)

_curriter_sysfile() = _repo_loopcontroldir("curriter")
_clamp_curriter(it) = clamp(round(Int, it), _GITWR_MIN_CURRITER, _GITWR_MAX_CURRITER)

function _set_curriter(it::Real = _GITWR_MIN_CURRITER)
    it = _clamp_curriter(it)
    fn = _curriter_sysfile()
    write(fn, string(it))
    return it
end

function _get_curriter()
    fn = _curriter_sysfile()
    it = _read_single_dat(fn, Int, _set_curriter)
    return _clamp_curriter(it)
end

function _update_curriter()
    iter = _get_curriter()
    _set_curriter(iter + 1)
end