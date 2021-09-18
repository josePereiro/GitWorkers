# ---------------------------------------------------------------
function _try_getpid(proc)
    try; return getpid(proc)
        catch err
        (err isa Base.IOError) && return -1
        rethrow(err)
    end
end

# ---------------------------------------------------------------
_append(io::IO, x, xs...) = print(io, x, xs...)
_append(fn::String, x, xs...) = open((io) -> print(io, x, xs...), fn, "a")

_empty!(io::IO) = nothing
_empty!(fn::String) = open((io) -> print(io, ""), fn, "w")

# ---------------------------------------------------------------
# take the content of a file and print it into a set of `ios`
function _tee_file(
        ios::Vector, file::String;
        finish_time::Ref{Float64}, lk::ReentrantLock,
        append = false, wt = 1.0
    )

    # check
    isempty(ios) && return

    # empty
    !append && _empty!.(ios)

    # tee
    _lmtime = -1.0
    _lli = 1
    while (time() < finish_time[])
        
        # wait for news
        (mtime(file) != _lmtime) ? 
            _lmtime = mtime(file) : 
            (sleep(wt); continue)
            
        # read
        all_lines = readlines(file; keep = true)
        (length(all_lines) < _lli) && continue

        # print to ios
        lock(lk) do
            lines = all_lines[_lli:end]
            for io in ios
                _append(io, lines...)
            end
            _lli = lastindex(all_lines) + 1
        end
    end

    return nothing
end

# ---------------------------------------------------------------
function _run(cmd; ios = [stdout], detach = true)

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

# ---------------------------------------------------------------
function _short_run(cmd; 
        stdout_log::String = _tempfile(), stderr_log::String = _tempfile(),
        stdout_tee_ios = [stdout], stderr_tee_ios = [stderr],
        append = false
    )

    # empty
    !append && _empty!.([stderr_log, stdout_log])
    
    # run
    cmd = pipeline(cmd, stdout=stdout_log, stderr=stderr_log; append)
    proc = run(cmd; wait = false)
    pid = _try_getpid(proc)
    wait(proc)

    # tee
    for (logfile, ios) in [
            (stdout_log, stdout_tee_ios), 
            (stderr_log, stderr_tee_ios)
        ]
        for io in ios
            !append && _empty!(io)
            _append(io, read(logfile, String))
        end
    end

    return pid
end

# ---------------------------------------------------------------
function _long_run(cmd; 
        stderr_log = _tempfile(), stdout_log = _tempfile(), 
        stdout_tee_ios = [stdout], stderr_tee_ios = [stderr],  
        lk = ReentrantLock(), timeout = time() + 1e9,
        savetime = 60.0, # To wait for flushing
        append = false
    )

    # empty
    !append && _empty!.([stderr_log, stdout_log])

    @sync begin

        proc = run(pipeline(cmd, stdout=stdout_log, stderr=stderr_log; append), wait=false)
        pid = _try_getpid(proc)

        # tee
        finish_time = Ref{Float64}(time() + timeout)
        stdout_tsk = @async _tee_file(stdout_tee_ios, stdout_log; finish_time, lk)
        stderr_tsk = @async _tee_file(stderr_tee_ios, stderr_log; finish_time, lk)

        # ending
        wait(proc)
        finish_time[] = time() + savetime
        wait(stdout_tsk)
        wait(stderr_tsk)
        
        return pid
    end

end

# ---------------------------------------------------------------
function _tee_run(cmd; long::Bool = false, runkwargs...)
    long ? _long_run(cmd; runkwargs...) : _short_run(cmd; runkwargs...)
end

# ---------------------------------------------------------------
function _run_bash(
        cmds::Vector{String};
        startup::Vector{String} = String[],
        buff_file = _tempname(),
        run_fun = _run,
        rm_buff = true,
        runkwargs...
    )

    touch(buff_file)
    chmod(buff_file, 0o755)

    src = join(filter(!isempty, [
        startup; 
        rm_buff ? "rm -f '$(buff_file)';" : ""; 
        cmds
    ]), "\n")
    # src = replace(src, "\"" => "\\\"")

    write(buff_file, src)

    run_fun(`bash -c $(buff_file)`; runkwargs...)
end