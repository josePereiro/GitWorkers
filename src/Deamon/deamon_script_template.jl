import GitWorkers
import GitWorkers: _run_deamon
import GitWorkers: GWDeamon
import GitWorkers: _GW_DEAMON_PROC_ID
import GitWorkers: _safe_killall
import GitWorkers: wid!
import GitWorkers: with_logger

## ---------------------------------------------------------------
# CLEAR SCRIPT
rm(@__FILE__; force = true)

## ---------------------------------------------------------------
# GWDeamon
DM = GWDeamon("__SYS_ROOT__")
wid!(DM, _GW_DEAMON_PROC_ID)

## ------------------------------------------------
# KILL OTHER SERVERS
if __FORCE__
    _safe_killall(DM, _GW_DEAMON_PROC_ID)
end

## ------------------------------------------------
# RUN SERVER LOOP
with_logger(DM) do
    _run_deamon(DM)
end

## ------------------------------------------------
# EXIT
exit()