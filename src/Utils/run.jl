function _read_bash(src::String; 
        verbose = true,
        cmdkwargs...
    )
    cmd = Cmd(`bash -c $(src)`; cmdkwargs...)
    out = read(cmd, String)
    verbose && println(out)
    return out
end

function _spawn_bash(src::String; cmdkwargs...)
    cmd = Cmd(`bash -c $(src)`; cmdkwargs...)
    proc = run(cmd; wait = false)
    return _try_getpid(proc)
end
