# getpid(proc)
function force_kill(pid::Integer; verb::Bool = true)
    try
        _run(`kill -SIGKILL $pid`; verb)
        return true
        catch; return false
    end
end