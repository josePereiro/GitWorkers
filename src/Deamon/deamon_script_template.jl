import GitWorkers
import GitWorkers: _run_server
import GitWorkers: GWDeamon
import GitWorkers: _GW_DEAMON_PROC_ID
import GitWorkers: _safe_killall
import GitWorkers: ptag!

## ---------------------------------------------------------------
# CLEAR SCRIPT
if __CLEAR_SCRIPT__
    rm(@__FILE__; force = true)
end

## ---------------------------------------------------------------
# GWDeamon
DM = GWDeamon("__SYS_ROOT__")
ptag!(DM, _GW_DEAMON_PROC_ID)

## ------------------------------------------------
# KILL OTHER SERVERS
if __FORCE__
    _safe_killall(DM, _GW_DEAMON_PROC_ID)
end

## ------------------------------------------------
# RUN SERVER LOOP
_run_server(DM;
    deb = __DEB__
)

## ------------------------------------------------
# EXIT
exit()