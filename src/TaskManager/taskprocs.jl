# TODO: Add tests
"""
    Store the running tasks and its related process info.
"""
TASKPROCS = Dict()
PROC_KEY = "PROC"
PID_KEY = "pid"


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

function run_taskproc(taskfile)
    
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")
    taskroot = taskfile |> get_taskroot
    
    # TODO: Handle this in config files
    julia_cmd = "julia"  # Test
    stdout_file = joinpath(taskroot, "local/stdout.txt") # Test
    stderr_file = joinpath(taskroot, "local/stderr.txt") # Test

    cmd = Cmd(`$julia_cmd $taskfile`, dir = taskfile |> dirname, env = ENV)
    proc = run_proc(cmd; stdout = open(stdout_file, "a"), stderr = open(stderr_file, "a"))
    add_taskproc(taskfile, proc)

    # Test
    pid = try_getpid(proc)
    println(taskfile, " proc ($pid) started!!!") # Test
    flush(stdout) 

    return proc

end

function kill_taskproc(taskfile)
    procs = get_taskprocs(taskfile);
    kill_proc(procs...)

    # Test
    println(relpath(taskfile), " proc killed!!!") 
    flush(stdout)
end