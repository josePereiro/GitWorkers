const _GW_TASK_OS_UPFREC = 5.0

## ------------------------------------------------------
function _run_task_os(gwt::GWTask)
    if is_worker_mode(gwt)

        # HANDLE STATUS
        _fatal_err(gwt) do
        
            _read_task_toml!(gwt)
            # check if pending
            curr_status = _get_task_status(gwt)
            !_is_pending_task(gwt) && 
                error("FATAL ERROR: Task status '$(curr_status)' != '$(_GW_TASK_PENDING_STATUS)'")

            # update
            _up_task_status!(gwt, _GW_TASK_RUNNING_STATUS)

            # PROC REGISTRY
            
            # SYS MAINTINANCE
            while true

                # PROC REGISTRY

                # FLUSH
                _flush()
                
                # SLEEP
                sleep(_GW_TASK_OS_UPFREC)
            end
            
        end

    end
end