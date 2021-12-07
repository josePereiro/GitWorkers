import GitWorkers
import GitWorkers: GitWorker
import GitWorkers: wid!, wid
import GitWorkers: _is_running
import GitWorkers: gitlink
import GitWorkers: run_gitlink_proc_os
import GitWorkers: with_logger
import GitLinks
import GitLinks: run_sync_loop

## ---------------------------------------------------------------
# CLEAR SCRIPT
rm(@__FILE__; force = true)

## ---------------------------------------------------------------
# GLOBALS
const GW = GitWorker(;
    sys_root = "__SYS_ROOT__",
    remote_url = "__REMOTE_URL__",
)
wid!(GW, "__GITLINK_PTAG__")

## ---------------------------------------------------------------
# OS
@async run_gitlink_proc_os(GW)

## ---------------------------------------------------------------
# CHECK PROC UNIQUENESS
if _is_running(GW, wid(GW))
    error("A $(wid(GW)) process is already running!!!")
    exit()
end

## ---------------------------------------------------------------
# GitLink loop
let
    gl = gitlink(GW)

    while true
        with_logger(GW) do
            run_sync_loop(gl; 
                tout = 60 * 60, # re-lunch in an hour
                verbose = true
            )
        end
    end

end

## ---------------------------------------------------------------
# EXIT
exit()
