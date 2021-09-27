# This is a RAM register for takin actions after a signal is updated
_SIGNALS_REGISTER = Dict()

_reg_signal(sigid, dat) = (_SIGNALS_REGISTER[sigid] = dat)
_get_signal_dat(sigid, dfl = nothing) = get(_SIGNALS_REGISTER, sigid, dfl)