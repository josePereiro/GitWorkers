function _sync_task_data()
    
    # logs
    _local_logs = _localdir(_GITWR_LOGS_RTDIR)
    _repo_logs = _repodir(_GITWR_LOGS_RTDIR)
    !isdir(_local_logs) && return
    !isdir(_repo_logs) && mkpath(_repo_logs)


    for local_log in readdir(_local_logs; join = true)
        _on_size_event(local_log; dofirst = true) do
            repo_log = _repover(local_log)
            _gwcp(local_log, repo_log)
        end
    end

end