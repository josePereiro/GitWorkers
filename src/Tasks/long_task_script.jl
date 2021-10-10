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
const _GW_EXPR_FILE = ARGS[2]
const _GW_SYS_ROOT = ARGS[3]
const _GW_REMOTE_URL = ARGS[4]

## ------------------------------------------------------------------
# atexit
atexit() do
    GitWorkers._rm(_GW_EXPR_FILE)
end

## ------------------------------------------------------------------
# SETUP
GitWorkers._local_setup(;
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
print("\n\n")

## ------------------------------------------------------------------
# EVAL EXPRS
try 
    _GW_TASK_EXPR = Serialization.deserialize(_GW_EXPR_FILE)
    GitWorkers._rm(_GW_EXPR_FILE)
    @sync GitWorkers.eval(_GW_TASK_EXPR)
catch err
    print("\n\n")
    GitWorkers._printerr(err)
    print("\n\n")
finally
    GitWorkers._rm(_GW_EXPR_FILE)
end

## ------------------------------------------------------------------
# FINISHED
# This is use to finish the following of a task. So, do not modify it
println("\n", rpad("FINISHED ", 60, "-"))
println("pid: ", getpid())
println("task id: ", _GW_TASKID)
print("\n\n")

## ------------------------------------------------------------------
# INSIST FLUSHING
for _ in 1:10
    flush(stdout)
    flush(stderr)
end

## ------------------------------------------------------------------
exit()