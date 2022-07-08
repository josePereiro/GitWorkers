## ----------------------------------------------------------------------
const _CURR_WORKER = GitWorker[]

function gw_curr()
    isempty(_CURR_WORKER) && error("No current GitWorker set (see `gw_curr(gw::GitWorker)`)")
    return first(_CURR_WORKER)
end

function gw_curr!(gw::GitWorker)
    empty!(_CURR_WORKER)
    push!(_CURR_WORKER, gw)
    return gw
end

## ----------------------------------------------------------------------
const _CURR_TASK = GWTaskRunTime[]

function gw_curr_task()
    isempty(_CURR_TASK) && error("No current GWTaskRunTime set (see `gw_curr_task!(trt::GWTaskRunTime)`)")
    return first(_CURR_TASK)
end

function gw_curr_task!(trt::GWTaskRunTime)
    empty!(_CURR_TASK)
    push!(_CURR_TASK, trt)
    return trt
end