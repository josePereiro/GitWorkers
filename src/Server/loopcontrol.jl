# ------------------------------------------------------
# PUSH FLAG
_pushflag_file() = _repo_loopcontroldir("pushflag")

_set_pushflag() = touch(_pushflag_file())

function _gw_pull_and_send_pushflag(;verb = false)
    _repo_update(;verb) do
        _set_pushflag()
        return true
    end
end

_check_pushflag() = isfile(_pushflag_file())

# ------------------------------------------------------
# LISTEN TIME
const _GW_MIN_LISTEN_WT = 0.5
const _GW_MAX_LISTEN_WT = 10.0
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

_curriter_file() = _repo_loopcontroldir("curriter")
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