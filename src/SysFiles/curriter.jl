# ------------------------------------------------------
# ITER FREC
const _GITWR_MIN_CURRITER = 1
const _GITWR_MAX_CURRITER = typemax(Int)

_curriter_sysfile() = _sysdir(".curriter")
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