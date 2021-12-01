function _task_id(tname::String)
    _date = Dates.now()
    tstr = Dates.format(_date, "yyyy-mm-dd-HHMMSS")
    return isempty(tname) ? tstr : string(tstr, "-", tname)
end
