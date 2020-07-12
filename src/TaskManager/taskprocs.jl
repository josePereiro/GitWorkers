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
function run_taskproc(taskfile; verbose = true)
    
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")
    taskroot = taskfile |> get_taskroot
    taskname = get_taskname(taskfile)
    exe_order = ORIGIN_CONFIG[taskname][EXE_ORDER_KEY][VALUE_KEY]
    
    # TODO: Handle this in config files
    julia_cmd = "julia"  # Test
    stdout_file = joinpath(taskroot, "local/logs/$(exe_order)-stdout.txt") # Test
    create_file(stdout_file)
    stderr_file = joinpath(taskroot, "local/logs/$(exe_order)-stderr.txt") # Test
    create_file(stderr_file)

    cmd = Cmd(`$julia_cmd $taskfile`, dir = taskfile |> dirname, env = ENV)
    proc = run_proc(cmd; stdout = open(stdout_file, "a"), stderr = open(stderr_file, "a"))
    add_taskproc(taskfile, proc)

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

    if verbose
        println(relpath(taskfile), " proc killed!!!") 
        flush(stdout)
    end
end