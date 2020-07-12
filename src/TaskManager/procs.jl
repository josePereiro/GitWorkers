"""
    Get if a process is running by trying to get the pid
"""
function is_running(proc::Base.Process)
    try
        getpid(proc)
        return true
    catch err
        err isa Base.IOError && return false
        rethrow(err)
    end
end

"""
    Try to get the pid of a process
    Returns nothing if fails
"""
function try_getpid(proc::Base.Process)
    try
        return getpid(proc)
    catch err
        err isa Base.IOError && return nothing
        rethrow(err)
    end
end

"""
    Run a command using `run` function but also add the process to the ALL_PROCS pull
    for the TaskManager
"""
function run_proc(cmd; stdout = stdout, stderr = stderr)
    proc = run(pipeline(cmd, stdout = stdout,  stderr = stderr), wait = false);
    push!(ALL_PROCS, proc)
    return proc
end

"""
    Try to kill all the process of the PROCS_TO_KILL
    array. If new process are passed, it will pushed to the array
    and the try to kill
"""
function kill_procs(procs...)
    foreach(procs) do proc
        push!(PROCS_TO_KILL, proc)
    end
    foreach(PROCS_TO_KILL) do proc
        kill(proc) # julia native way
        # system native
        pid = try_getpid(proc)
        if !isnothing(pid)
            # TODO: implement for more systems
            if Sys.isunix()
                try
                    run(`kill $pid`)
                catch err
                    err isa InterruptException && rethrow(err)
                    # TODO Log this
                end
            end
        end
    end
end

function killEmAll() 
    kill_procs(ALL_PROCS...)
end
atexit(killEmAll)