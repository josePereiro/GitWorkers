## ------------------------------------------------------
# REGISTER PROC
_proc_sysfile(pid::Integer) = _sysdir(string(pid, ".proc"))

function _reg_proc(pid::Integer; 
        desc::String = "", 
        lstart::String = _get_proc_lstart(pid)
    )
    fn = _proc_sysfile(pid)
    return _write_toml(fn; pid, desc, lstart)
end

function _find_pid_reg(pid)
    pid = string(pid)
    dir = _repodir(_GITWR_SYSFILES_DIR)
    return filter(readdir(dir)) do name
        startswith(name, pid) && endswith(name, ".proc")
    end
end

# validate if a proc is active and is registered
function _validate_proc(pid::Integer)
    fn = _proc_sysfile(pid)
    dat = _read_toml(fn)
    reg_lstart = get(dat, "lstart", -1)
    curr_lstart = _get_proc_lstart(pid)
    reg_lstart == curr_lstart
end