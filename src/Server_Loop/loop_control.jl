# ------------------------------------------------------
# PUSH FLAG
const _GW_PUSHFLAG_NAME = "pushflag"

_pushflag_file() = _repo_loop_control_dir(_GW_PUSHFLAG_NAME)

_set_pushflag() = touch(_pushflag_file())

_check_pushflag() = isfile(_pushflag_file())

# ------------------------------------------------------
# LISTEN TIME
const _GW_MIN_LISTEN_WT = 0.5
const _GW_MAX_LISTEN_WT = 25.0
const _GW_CURR_LISTEN_WT = Ref{Float64}(_GW_MIN_LISTEN_WT)
const _GW_DELTA_LISTEN_WT = 0.1


_reset_listen_wait() = (_GW_CURR_LISTEN_WT[] = _GW_MIN_LISTEN_WT)

function _listen_wait()
    
    println("\nJust listening, time: ", now())
    
    wt = clamp(_GW_CURR_LISTEN_WT[], _GW_MIN_LISTEN_WT, _GW_MAX_LISTEN_WT)
    _GW_CURR_LISTEN_WT[] += _GW_DELTA_LISTEN_WT
    sleep(wt)
end

# ------------------------------------------------------
# CURR ITER
const _GW_MIN_CURRITER = 1
const _GW_MAX_CURRITER = typemax(Int)

_curriter_file() = _repo_loop_control_dir("curriter")
_clamp_curriter(it) = clamp(round(Int, it), _GW_MIN_CURRITER, _GW_MAX_CURRITER)

function _set_curriter(it::Real = _GW_MIN_CURRITER)
    it = _clamp_curriter(it)
    fn = _curriter_file()
    write(fn, string(it))
    return it
end

function _get_curriter()
    fn = _curriter_file()
    it = _read_single_dat(fn, Int, _set_curriter)
    return _clamp_curriter(it)
end

function _update_curriter()
    iter = _get_curriter()
    _set_curriter(iter + 1)
end