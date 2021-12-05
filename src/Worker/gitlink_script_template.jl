import GitWorkers
import GitWorkers: GitWorker
import GitWorkers: ptag!, ptag
import GitWorkers: _is_running
import GitWorkers: gitlink
import GitWorkers: run_gitlink_proc_os
import GitLinks
import GitLinks: run_sync_loop

## ---------------------------------------------------------------
# CLEAR SCRIPT
if __CLEAR_SCRIPT__
    rm(@__FILE__; force = true)
end

## ---------------------------------------------------------------
# GLOBALS
const GW = GitWorker(;
    sys_root = "__SYS_ROOT__",
    remote_url = "__REMOTE_URL__",
)
ptag!(GW, "__GITLINK_PTAG__")

## ---------------------------------------------------------------
# OS
@async run_gitlink_proc_os(GW)

## ---------------------------------------------------------------
# CHECK PROC UNIQUENESS
if _is_running(GW, ptag(GW))
    error("A $(ptag(GW)) process is already running!!!")
    exit()
end

## ---------------------------------------------------------------
# GitLink loop
let
    gl = gitlink(GW)

    while true
        run_sync_loop(gl; 
            tout = 60 * 60, # re-lunch in an hour
            verbose = __GL_VERBOSE__
        )
    end

end

## ---------------------------------------------------------------
# EXIT
exit()
