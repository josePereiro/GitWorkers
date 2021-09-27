# ------------------------------------------------------
# PUSH FLAG
_pushflag_sysfile() = _sysdir(".pushflag")

_set_pushflag() = touch(_pushflag_sysfile())

function _check_pushflag() 
    fn = _pushflag_sysfile()
    flag = isfile(fn)
    _gwrm(fn)
    return flag
end