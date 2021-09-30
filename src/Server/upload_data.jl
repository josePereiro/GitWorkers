function _upload_logs()
    
    # logs
    _local_logs = _local_logsdir()
    _repo_logs = _repo_logsdir()
    !isdir(_local_logs) && return
    !isdir(_repo_logs) && mkpath(_repo_logs)


    for local_log in _readdir(_local_logs; join = true)
        
        # Maintinance
        !_is_log(local_log) && rm(local_log)

        # copy if required
        # this assume that any change in the log change its size
        _on_size_event(local_log; dofirst = true) do
            repo_log = _repover(local_log)
            _cp(local_log, repo_log)
        end
    end

end

_upload_procs() = _syncdirs(_local_procsdir(), _repo_procsdir())