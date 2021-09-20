const _TODEL = String[]

_reg_todel(fn, fns...) = push!(_TODEL, fn, fns...)

_delall() = foreach((fn) -> rm(fn; recursive = true, force = true), _TODEL)