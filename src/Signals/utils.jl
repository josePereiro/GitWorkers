function _read_single_dat(fn, T, dflfun::Function)
    !isfile(fn) && return dflfun()
    temp = tryparse(T, read(fn, String))
    return isnothing(temp) ? dflfun() : temp
end
_read_single_dat(fn, T, dfl) = _read_single_dat(fn, T, () -> dfl)

