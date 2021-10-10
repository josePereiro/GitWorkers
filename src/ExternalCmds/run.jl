# ---------------------------------------------------------------
# Taked from ExternalCmds (https://github.com/josePereiro/ExternalCmds.jl)
function _run_cmd(cmd; ios = [stdout], detach = false)

    # run
    _out = Pipe()
    cmd = pipeline(Cmd(cmd; detach), stdout = _out, stderr = _out)
    proc = run(cmd, wait = false)
    pid = _try_getpid(proc)
    wait(proc)
    
    # out
    close(_out.in)
    out = read(_out, String)
    
    # print
    for io in ios
        _append(io, out)
    end

    return (;pid, out)
end