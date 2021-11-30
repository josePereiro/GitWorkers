# worker mode
const _GW_RUNME_WORKERMODE_FlAG = "-w"
is_worker_mode(gwt::GWTask) = get!(gwt, _GW_RUNME_WORKERMODE_FlAG, false)

function _parse_args!(gwt::GWTask, argv)
    # worker mode
    set!(gwt, _GW_RUNME_WORKERMODE_FlAG, any(argv .== _GW_RUNME_WORKERMODE_FlAG))
end
