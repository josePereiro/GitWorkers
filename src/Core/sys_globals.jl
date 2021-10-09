# In RAM configuration
const _SYSTEM_GLOBALS = Dict{String, Any}()

function _set_global!(k, v)
    _SYSTEM_GLOBALS[string(k)] = v
    return v
end

function _get_global(k)
    !haskey(_SYSTEM_GLOBALS, k) && error("global '$k' not set. To start a client uses `gw_setup_client` and to start a server use `_run_main`")
    _SYSTEM_GLOBALS[k]
end

_has_global(k) = haskey(_SYSTEM_GLOBALS, k)

_get_url() = _get_global("url")
_set_url!(url) = _set_global!("url", url)

_get_root() = _get_global("root")
_set_root!(root) = _set_global!("root", root)

## ---------------------------------------------------------------------------
# write globals
const _GW_GLOBALS_FILE_NAME = "gitworker.toml"
_globals_file(urldir = _urldir()) = _mkdirpath(joinpath(urldir, _GW_GLOBALS_FILE_NAME))
_read_globals(urldir = _urldir()) = _read_toml(_globals_file(urldir))
_write_globals() = _write_toml(_globals_file(), _SYSTEM_GLOBALS)