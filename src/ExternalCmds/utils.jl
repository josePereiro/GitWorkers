_try_getpid(proc) = try
    return getpid(proc) 
    catch; return -1 
end

_force_kill(pid) = try
    pid = string(pid)
    pid == "-1" && return false
    run(`kill -SIGKILL $(pid)`; wait = true)
    return true
    catch; return false
end

const _GW_PS_CMD_OUT_STRIP_PATTERN = ['\t', ' ', '\n']
_get_proc_lstart(pid) = try
    pid = string(pid)
    pid == "-1" && return ""
    ret = read(`ps -p $(pid) -o lstart=`, String)
    return string(strip(ret, _GW_PS_CMD_OUT_STRIP_PATTERN))
    catch; return ""
end

_get_proc_lstart() = _get_proc_lstart(getpid())

_append(io::IO, x, xs...) = print(io, x, xs...)
_append(fn::AbstractString, x, xs...) = open((io) -> print(io, x, xs...), fn, "a")