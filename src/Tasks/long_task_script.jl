## ------------------------------------------------------------------
# IMPORT
# This is suppost to be run in an enviroment that has GitWorkers installed
# I'll use the server environment
try; import GitWorkers
catch err
    import Pkg
    Pkg.add("GitWorkers")
    import GitWorkers
end
import GitWorkers
import GitWorkers.Serialization

## ------------------------------------------------------------------
# ARGS
const _GW_TASKID = ARGS[1]
const _GW_TASK_FILE = ARGS[2]
const _GW_SYS_ROOT = ARGS[3]
const _GW_REMOTE_URL = ARGS[4]

## ------------------------------------------------------------------
# atexit
atexit() do
    rm(_GW_TASK_FILE; force = true)
end

## ------------------------------------------------------------------
# SETUP
GitWorkers._setup_gitworker_local_part(;
    url = _GW_REMOTE_URL, sys_root = _GW_SYS_ROOT
)

## ------------------------------------------------------------------
# TASK OS
@async GitWorkers._run_log_task_os(_GW_TASKID)

## ------------------------------------------------------------------
# WELCOME
println("\n", rpad("STARTING ", 60, "-"))
println("pid: ", getpid())
println("task id: ", _GW_TASKID)
println("\n\n")

## ------------------------------------------------------------------
# EVAL EXPRS
try 
    _GW_TASK_CMD = Serialization.deserialize(_GW_TASK_FILE)
    rm(_GW_TASK_FILE; force = true)
    @sync GitWorkers.eval(_GW_TASK_CMD.expr)
catch err
    print("\n\n")
    GitWorkers._printerr(err)
    print("\n\n")
finally
    rm(_GW_TASK_FILE; force = true)
end

## ------------------------------------------------------------------
# FINISHED
println("\n FINISHED ----------------------------------")
println("pid: ", getpid())
println("task id: ", _GW_TASKID)
println("\n\n")

## ------------------------------------------------------------------
# INSIST FLUSHING
for _ in 1:10
    flush(stdout)
    flush(stderr)
end

## ------------------------------------------------------------------
exit()