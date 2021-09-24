const _GITWR_LOOPCONTROL_DIR = ".loopcontrol"

# ------------------------------------------------------
const _GITWR_MIN_ITERFREC = 1.0
const _GITWR_MAX_ITERFREC = 3600.0
const _GITWR_DEFLT_ITERFREC = 25.0
const _GITWR_ITER_FRACWT = 3.0

_iterfrec_controlfile() = _repodir(_GITWR_LOOPCONTROL_DIR, ".iterfrec")

function _set_iterfrec(ptime::Real = _GITWR_DEFLT_ITERFREC)
    ptime = clamp(float(ptime), _GITWR_MIN_ITERFREC, _GITWR_MAX_ITERFREC)
    fn = _iterfrec_controlfile()
    write(fn, string(ptime))
    return ptime
end

function _load_iterfrec()
    fn = _iterfrec_controlfile()
    !isfile(fn) && _set_iterfrec()
    pf = tryparse(Float64, read(fn, String))
    return isnothing(pf) ? _set_iterfrec() : clamp(pf, _GITWR_MIN_ITERFREC, _GITWR_MAX_ITERFREC)
end