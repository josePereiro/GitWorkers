const _GW_REG_RKEY_KEY = "_rkey"
const _GW_REG_RFILE_KEY = "_rfile"

function _prepare_gwreg_dat(gw::GitWorker, rkey; dat...)
    gwdat = TkeyDict(dat, String)
    gwdat[_GW_REG_RKEY_KEY] = string(rkey)
    return gwdat
end

# reg `dat` plus some gw related data
function up_gwreg_and_gwtoml!(gw::GitWorker, fn::String, rkey; dat...)
    _mkdir(fn)
    gwreg = _gw_reg(gw, rkey; dat...)
    # will force ram representation to have the disk version path
    gwreg[_GW_REG_RFILE_KEY] = worker_relpath(gw, rfile) # cross-machine compatible 
    _write_toml(fn, gwreg) # disk rep
    up_gwreg!(gw, gwreg) # ram rep
    return gw
end

# update dat ram representation
function up_gwreg!(gw::GitWorker, gwreg::Dict)

    rkey = get(gwreg, _GW_REG_RKEY_KEY, nothing)
    isnothing(rkey) && return gw

    # overwrite old
    set!(gw, rkey, gwreg)

    return gw
end

function up_gwreg!(gw::GitWorker, rkey::String; dat...)
    gwreg = _gw_reg(gw, rkey; dat...)
    up_gwreg!(gw, gwreg)
end


# load fn and update its ram representation
function up_from_gwtoml!(gw::GitWorker, fn::String)
    !isfile(rfile) && return gw
    gwtoml = _read_toml(fn)
    up_gwreg!(gw, gwtoml)
end

## ------------------------------------------------------------------
# Utils

function TkeyDict(nTkdict::Dict, T::DataType, convfun = T)
    Tkdict = Dict{T, Any}()
    for (nTk, dat) in nTkdict
        Tkdict[convfun(nTk)] = dat
    end
    return Tkdict
end
TkeyDict(nt::NamedTuple, T::DataType, convfun = T) =
    TkeyDict(Dict(pairs(nt)...), T, convfun)