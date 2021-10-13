# ------------------------------------------------------
# PUSH FLAG
const _GW_PUSHFLAG_NAME = "pushflag"

_pushflag_file() = _repo_loop_control_dir(_GW_PUSHFLAG_NAME)

_set_pushflag() = touch(_pushflag_file())

_check_pushflag() = isfile(_pushflag_file())

# ------------------------------------------------------
# LISTEN TIME
# mins from reset => wait time
const _GW_SERVER_LOOP_SLEEP_PROGRAM = SleepProgram(2*60 => 2, 10*60 => 15, 30*60 => 60)

_reset_server_loop_listen_wait() = reset!(_GW_SERVER_LOOP_SLEEP_PROGRAM)

function _server_loop_listen_wait()
    println("\nJust listening, time: ", now())
    sleep(_GW_SERVER_LOOP_SLEEP_PROGRAM)
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