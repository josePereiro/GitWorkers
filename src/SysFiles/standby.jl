# ------------------------------------------------------
# STANDBY SIG
_standby_sigfile() = _sysdir(".standby")

_send_standby_sig() = touch(_standby_sigfile())

_check_standby_sig() = isfile(_standby_sigfile())

_clear_standby_sig() = rm(_standby_sigfile(); force = true)