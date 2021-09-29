_dummy_file() = _repodir(".dummy")
_touch_dummy() = write(_dummy_file(), _gen_id())

"""
    print the err text
"""
function printerr(io::IO, err; max_len = 10000)
    s = sprint(showerror, err, catch_backtrace())
    print(io, length(s) > max_len ? s[1:max_len] * "\n[...]" : s)
end
printerr(err; max_len = 10000) = printerr(stdout, err; max_len)


function _dict(d = Dict{String, Any}(); kwargs...) 
	for (k, v) in kwargs
		d[string(k)] = v
	end
	return d
end

_write_toml(fn; kwargs...) = _write_toml(fn, _dict(;kwargs...))

_write_toml(fn, dat::Dict) = open(fn, "w") do io
    TOML.print(io, dat; sorted=true)
    return fn
end

function _read_toml(fn)
    !isfile(fn) && return Dict{String, Any}()
    try; return TOML.parsefile(fn)
    catch err
        (err isa Base.TOML.ParserError) && return Dict{String, Any}()
        rethrow(err)
    end
end

function _has_content(fn; kwargs...)
    dat = _read_toml(fn)
    isempty(kwargs) && return false
    for (k0, v0) in kwargs
        (v0 != get(dat, string(k0), nothing)) && return false
    end
    return true
end