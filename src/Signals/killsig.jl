# ------------------------------------------------------
# KILL SIG
const _GW_KILLSIG_EXT = ".killsig"
_killsig_name(pid) = string(pid, _GW_KILLSIG_EXT)
_is_killsig_name(fn) = _endswith(fn, _GW_KILLSIG_EXT)
_local_killsig_file(pid) = _local_signals_dir(_killsig_name(pid))
_repo_killsig_file(pid) = _repo_signals_dir(_killsig_name(pid))

_set_killsig(pid; tag = "", unsafe = false) = _write_toml(_repo_killsig_file(pid); pid, tag, unsafe)