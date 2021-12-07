import GitWorkers
import GitWorkers: GitWorker
import GitWorkers: wid!, wid
import GitWorkers: _is_running
import GitWorkers: _run_tasks_admin_loop
import GitWorkers: _run_tasks_admin_proc_os
import GitWorkers: with_logger

## ---------------------------------------------------------------
# CLEAR SCRIPT
rm(@__FILE__; force = true)

## ---------------------------------------------------------------
# GLOBALS
const GW = GitWorker(;
    sys_root = "__SYS_ROOT__",
    remote_url = "__REMOTE_URL__",
)
wid!(GW, "__PTAG__")

## ---------------------------------------------------------------
# OS
@async _run_tasks_admin_proc_os(GW)

## ---------------------------------------------------------------
# CHECK PROC UNIQUENESS
if _is_running(GW, wid(GW))
    error("A $(wid(GW)) process is already running!!!")
    exit()
end

## ---------------------------------------------------------------
# tasks admin loop
let

    while true
        with_logger(GW) do
            
            @info("Starting Tasks Admin", pid = getpid())

            _run_tasks_admin_loop(GW)
        end
    end

end

## ---------------------------------------------------------------
# EXIT
exit()
