"""
    Store all processes that the TaskManager tagged to kill. 
"""
PROCS_TO_KILL = Set{Base.Process}()

"""
    Store of all child processes
"""
ALL_PROCS = Set{Base.Process}()

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
    Returns 0 if fails
"""
function try_getpid(proc)
    try
        return getpid(proc)
    catch err
        err isa Base.IOError && return 0
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

function kill_proc(procs...)
    foreach(procs) do proc
        push!(PROCS_TO_KILL, proc)
    end
    foreach(PROCS_TO_KILL) do proc
        kill(proc)
    end
end

function killEmAll() 
    println("killEmAll") # Test
    kill_proc(ALL_PROCS...)
end
atexit(killEmAll)