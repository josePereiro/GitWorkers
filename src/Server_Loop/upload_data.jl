function _upload_tasks_outs()
    
    # outs
    _local_outs = _local_tasks_outs_dir()
    _repo_outs = _repo_tasks_outs_dir()
    !isdir(_local_outs) && return
    !isdir(_repo_outs) && mkpath(_repo_outs)


    for local_out in _readdir(_local_outs; join = true)
        
        # some maintinance
        !_is_taskout(local_out) && rm(local_out)

        # copy if required
        # this assume that any change in the out file change its size
        _on_size_event(local_out; atmissing = true) do
            repo_out = _repover(local_out)
            _cp(local_out, repo_out)
        end
    end

end

_upload_procs() = _syncdirs(_local_procs_dir(), _repo_procs_dir())