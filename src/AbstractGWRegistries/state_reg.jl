const _GW_REG_KEY = "_register"
const _GW_REG_RFILE_KEY = "_rfkey"
const _GW_REG_UPTIME_KEY = "_uptime"

# homedir
import Base.homedir
homedir(r::AbstractGWRegistry) = r.home_dir

# relpath
Base.relpath
relpath(r::AbstractGWRegistry, path::String) = _relbasepath(path, homedir(r))

# access registry
function reg_sdat!(r::AbstractGWRegistry, fkey::String, dat)
    rfkey = relpath(r, fkey)

    # ram version
    keys = splitpath(rfkey)
    sdat = get_sreg(r)
    for k in keys
        sdat = get!(sdat, k, Dict{String, Any}())
    end

    for (dk, val) in dat
        sdat[string(dk)] = val
    end
    sdat[_GW_REG_RFILE_KEY] = rfkey # cross-machine compatible 
    sdat[_GW_REG_UPTIME_KEY] = time() 

    return sdat
end

reg_sdat!(r::AbstractGWRegistry, fkey::String; dat...) = reg_sdat!(r::AbstractGWRegistry, fkey::String, dat)

get_sreg(r::AbstractGWRegistry) = get!(() -> Dict{String, Any}(), r, _GW_REG_KEY)

function get_sdat(r::AbstractGWRegistry, rkey::String) 
    rfkey = worker_relpath(r, rkey)

    keys = splitpath(rfkey)
    dict = get_sreg(r)
    for k in keys
        dict = get!(dict, k) do
            Dict{String, Any}()
        end
    end
    return dict
end

function empty_sreg!(r::AbstractGWRegistry, rkey::String) 
    sdat = get_sdat(r, rkey)
    (sdat isa Dict) && empty!(sdat)
    return sdat
end

function _find_by_khint(r::AbstractGWRegistry, rootk, khint)
    khint = string(khint)
    sdat = get_sdat(r, rootk)
    for (k, dat) in sdat
        contains(k, khint) && return dat
    end
    return Dict{String, Any}()
end


