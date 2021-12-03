const _GW_REG_KEY = "_register"
const _GW_REG_RFILE_KEY = "_rfkey"
const _GW_REG_UPTIME_KEY = "_uptime"

# access registry
function reg_sdat!(w::AbstractWorker, fkey::String, dat)
    rfkey = relpath(w, fkey)

    # ram version
    keys = splitpath(rfkey)
    sdat = get_sreg(w)
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

reg_sdat!(w::AbstractWorker, fkey::String; dat...) = reg_sdat!(w::AbstractWorker, fkey::String, dat)

get_sreg(w::AbstractWorker) = get!(() -> Dict{String, Any}(), w, _GW_REG_KEY)

function get_sdat(w::AbstractWorker, rkey::String) 
    rfkey = worker_relpath(w, rkey)

    keys = splitpath(rfkey)
    dict = get_sreg(w)
    for k in keys
        dict = get!(dict, k) do
            Dict{String, Any}()
        end
    end
    return dict
end

function empty_sreg!(w::AbstractWorker, rkey::String) 
    sdat = get_sdat(w, rkey)
    (sdat isa Dict) && empty!(sdat)
    return sdat
end

function _find_by_khint(w::AbstractWorker, rootk, khint)
    khint = string(khint)
    sdat = get_sdat(w, rootk)
    for (k, dat) in sdat
        contains(k, khint) && return dat
    end
    return Dict{String, Any}()
end


