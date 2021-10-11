# ------------------------------------------------------
# RESET SIG
const _GW_RESETSIG_EXT = ".resetsig"
_resetsig_name() = _GW_RESETSIG_EXT
_is_resetsig_file(fn) = _endswith(fn, _GW_RESETSIG_EXT)
_local_resetsig_file() = _local_signals_dir(_resetsig_name())
_repo_resetsig_file() = _repo_signals_dir(_resetsig_name())

_set_resetsig(;update = false) = _write_toml(_repo_resetsig_file(); update)
