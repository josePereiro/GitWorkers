# getpid(proc)
function force_kill(pid::Integer)
    try
        run(`kill -SIGKILL $pid`)
        return true
        catch; return false
    end
end

function _get_proc_lstart(pid)
    try
	    ret = read(`ps -p $(pid) -o lstart=`, String)
	    return string(strip(ret, [' ', ' ', '\n']))
        catch; return ""
    end
end

_get_proc_lstart() = _get_proc_lstart(getpid())
