const _GW_TASK_OS_UPFREC = 5.0

## ------------------------------------------------------
function _run_task_os(gwt::GWTask)
    if is_worker_mode(gwt)

        # HANDLE STATUS
        _fatal_err(gwt) do
        
            # go it done
            if _is_done_task(gwt)
                sleep(3.0)
                exit()
            end

            # check if pending
            !_is_spawned_task(gwt) &&
                error("FATAL ERROR: Task status '$(_get_task_status(gwt))'")

            # update
            _up_task_status(gwt, _GW_TASK_RUNNING_STATUS)

            # PROC REGISTRY
            _reg_proc(gwt, task_id(gwt))
            
            # SYS MAINTINANCE
            while true

                # PROC REGISTRY
                _reg_proc(gwt, task_id(gwt))

                # FLUSH
                _flush_all()
                
                # SLEEP
                sleep(_GW_TASK_OS_UPFREC)
            end
            
        end

    end
end