# ------------------------------------------------------
# ITER FREC
const _GITWR_MIN_ITERFREC = 1.0
const _GITWR_MAX_ITERFREC = 3600.0
const _GITWR_DEFLT_ITERFREC = 25.0
const _GITWR_ITER_FRACWT = 3.0

_iterfrec_sysfile() = _sysdir(".iterfrec")
_clamp_iterfrec(frec) = clamp(float(frec), _GITWR_MIN_ITERFREC, _GITWR_MAX_ITERFREC)

function _set_iterfrec(frec::Real = _GITWR_DEFLT_ITERFREC)
    fn = _iterfrec_sysfile()
    frec = _clamp_iterfrec(frec)
    write(fn, string(frec))
    return frec
end

function _get_iterfrec()
    fn = _iterfrec_sysfile()
    frec = _read_single_dat(fn, Float64, _set_iterfrec)
    return _clamp_iterfrec(frec)
end