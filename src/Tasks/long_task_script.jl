## ------------------------------------------------------------------
# imports
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
# Args
const _GW_TASKID = ARGS[1]
const _GW_TASK_FILE = ARGS[2]
const _GW_SYS_ROOT = ARGS[3]
const _GW_REMOTE_URL = ARGS[4]

## ------------------------------------------------------------------
# setup worker
GitWorkers._setup_gitworker_local_part(;
    url = _GW_REMOTE_URL, sys_root = _GW_SYS_ROOT
)

## ------------------------------------------------------------------
# TASK OS
_GW_TASK_RUNNING = true
@async while _GW_TASK_RUNNING
    
    # REG PROC
    GitWorkers._reg_proc(getpid(); desc = _GW_TASKID)

    # FLUSH
    flush(stdout)
    flush(stderr)

    # WAIT
    sleep(5.0)
end

## ------------------------------------------------------------------
# WELCOME
println("\n", rpad("STARTING ", 60, "-"))
println("pid: ", getpid())
println("task id: ", _GW_TASKID)
println("\n\n")

## ------------------------------------------------------------------
# eval expr
_rtcmd = GitWorkers.Serialization.deserialize(_GW_TASK_FILE)
@sync GitWorkers.eval(_rtcmd.expr)

## ------------------------------------------------------------------
_GW_TASK_RUNNING = false

## ------------------------------------------------------------------
# FINISHED
println("\n FINISHED ----------------------------------")
println("pid: ", getpid())
println("task id: ", _GW_TASKID)
println("\n\n")

## ------------------------------------------------------------------
# insist
for _ in 1:10
    flush(stdout)
    flush(stderr)
end

## ------------------------------------------------------------------
exit()