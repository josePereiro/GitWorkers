const _GW_REG_KEY = "_register"
const _GW_REG_RFILE_KEY = "_rfkey"
const _GW_REG_UPTIME_KEY = "_uptime"

function reg_sdat!(gw::GitWorker, fkey::String, dat)
    rfkey = worker_relpath(gw, fkey)

    # ram version
    keys = splitpath(rfkey)
    sdat = get_sreg(gw)
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

reg_sdat!(gw::GitWorker, fkey::String; dat...) = reg_sdat!(gw::GitWorker, fkey::String, dat)

get_sreg(gw::GitWorker) = get!(() -> Dict{String, Any}(), gw, _GW_REG_KEY)

function get_sdat(gw::GitWorker, rkey::String) 
    rfkey = worker_relpath(gw, rkey)

    keys = splitpath(rfkey)
    dict = get_sreg(gw)
    for k in keys
        dict = get!(dict, k) do
            Dict{String, Any}()
        end
    end
    return dict
end

function empty_sreg!(gw::GitWorker, rkey::String) 
    sdat = get_sdat(gw, rkey)
    (sdat isa Dict) && empty!(sdat)
    return sdat
end

function _find_by_khint(gw::GitWorker, rootk, khint)
    khint = string(khint)
    sdat = get_sdat(gw, rootk)
    for (k, dat) in sdat
        contains(k, khint) && return dat
    end
    return Dict{String, Any}()
end


