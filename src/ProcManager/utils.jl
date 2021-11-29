const _GW_PS_CMD_OUT_STRIP_PATTERN = ['\t', ' ', '\n']
_get_proc_lstart(pid) = try
    pid = string(pid)
    pid == "-1" && return ""
    out = read(`ps -p $(pid) -o lstart=`, String)
    return string(strip(out, _GW_PS_CMD_OUT_STRIP_PATTERN))
    catch; return ""
end