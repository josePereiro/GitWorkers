const _CURR_WORKER = GitWorker[]

function gw_curr()
    isempty(_CURR_WORKER) && error("No current GitWorker set (see `gw_curr(gw::GitWorker)`)")
    return first(_CURR_WORKER)
end

function gw_curr(gw::GitWorker)
    empty!(_CURR_WORKER)
    push!(_CURR_WORKER, gw)
    return gw
end