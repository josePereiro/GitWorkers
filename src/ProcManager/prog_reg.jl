const _PROC_REG_KEY = :proc_reg

_proc_reg_file(gw::GitWorker, pid, pname) = joinpath(gw_procs_dir(gw), string(pid, ".", pname, ".toml"))

function _register_proc!(gw::GitWorker, pid, pname)

    lstart = _get_proc_lstart(pid)
    isempty(lstart) && return false
    
    # up disk (create )
    rfile = _proc_reg_file(gw, pid, pname)
    _mkdir(rfile)
    _write_toml(rfile; 
        lstart, pid, 
        rkey = _PROC_REG_KEY,
        file = worker_relpath(gw, rfile) # cros-smachine compatible
    )
    
    # up ram
    

    return rfile
end



function _validate_proc!(gw::GitWorker, pid)
end