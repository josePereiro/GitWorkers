function _kill_proc(pid; unsafe = false)
    if unsafe || _validate_proc(pid)
        _force_kill(pid)
    end
end

