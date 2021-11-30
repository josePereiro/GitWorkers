
function _run_taskos(gw::GitWorker)
    while true
        
        println("Running taskos")
        _flush()

        sleep(_GW_TASK_OS_UPFREC)
    end
end