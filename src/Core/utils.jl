_dummy_file() = _repodir(".dummy")
_touch_dummy() = write(_dummy_file(), _gen_id())

_err_str(err) = sprint(showerror, err, catch_backtrace())

"""
    print the err text
"""
_printerr(io::IO, err) = print(io, _err_str(err))
_printerr(err) = _printerr(stdout, err)

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

_endswith(text, suffix) = endswith(string(text), string(suffix))

function _print_file(file, c0 = 1, c1 = typemax(Int); buffsize = 500)
    c = 1
    bi = 0
    buff = Vector{Char}(undef, buffsize)
    open(file) do io
        while !eof(io)
            ch = read(io, Char)
            c += 1

            (c < c0) && continue
            (c >= c1) && break

            bi += 1
            buff[bi] = ch
            if (bi == buffsize)
                print(join(buff))
                bi = 0
            end
        end
        
        if bi > 0
            print(join(buff[1:bi]))
        end
    end
    return c
end
