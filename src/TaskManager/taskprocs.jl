# TODO: Add tests

function is_taskrunning(taskfile) 
    !haskey(TASKPROCS, taskfile) && return false
    return get_taskprocs(taskfile) .|> is_running |> any
end

function get_taskprocs(taskfile) 
    !haskey(TASKPROCS, taskfile) && return []
    return TASKPROCS[taskfile][PROC_KEY]
end

function add_taskproc(taskfile, proc)
    if !haskey(TASKPROCS, taskfile)
        TASKPROCS[taskfile] = Dict()
        TASKPROCS[taskfile][PID_KEY] = []
        TASKPROCS[taskfile][PROC_KEY] = []
    end

    push!(TASKPROCS[taskfile][PID_KEY], try_getpid(proc))
    push!(TASKPROCS[taskfile][PROC_KEY], proc)
    return proc
end

"""
    This run a given task in a child process
"""
function run_taskproc(taskfile, exec_order; verbose = true)
    
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")
    taskroot = taskfile |> get_taskroot
    taskname = taskfile |> get_taskname
    
    # TODO: Handle this in config files
    julia_cmd = "julia"  # Test
    stdout_file = get_stdout_file(taskfile, exec_order; allow_missing = true) |> create_file
    stderr_file = get_stderr_file(taskfile, exec_order; allow_missing = true) |> create_file

    cmd = Cmd(`$julia_cmd $taskfile`, dir = taskfile |> dirname, env = ENV)
    proc = run_proc(cmd; stdout = open(stdout_file, LOG_FIlES_MODE), 
        stderr = open(stderr_file, LOG_FIlES_MODE))
    add_taskproc(taskname, proc)

    if verbose
        pid = try_getpid(proc)
        println(taskfile, " proc ($pid) started!!!") # Test
        flush(stdout) 
    end

    return proc

end

"""
    This will try to kill all the process linked to a task. 
    The implementation of how to kill a process it is in the 
    'kill_procs' method
"""
function kill_taskproc(taskfile; verbose = true)
    procs = get_taskprocs(taskfile);
    kill_procs(procs...)

    # TODO: log this
    if verbose
        println(taskfile |> get_taskname, " proc killed!!!") 
        flush(stdout)
    end
end