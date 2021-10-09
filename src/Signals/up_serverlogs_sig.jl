# ------------------------------------------------------
# KILL SIG
const _GITGW_UPSERVERLOGS_SIG_EXT = ".up_serverlog_sig"
_up_serverlogs_sig_name() = string(_GITGW_UPSERVERLOGS_SIG_EXT)
_is_up_serverlogs_sig_name(fn) = _endswith(fn, _GITGW_UPSERVERLOGS_SIG_EXT)
_local_up_serverlogs_sig_file() = _local_signals_dir(_up_serverlogs_sig_name())
_repo_up_serverlogs_sig_file() = _repo_signals_dir(_up_serverlogs_sig_name())

_set_up_serverlogs_sig(; deep = 2) = _write_toml(_repo_up_serverlogs_sig_file(); deep)
