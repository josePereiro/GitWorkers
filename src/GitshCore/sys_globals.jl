# In RAM configuration
const _SYSTEM_GLOBALS = Dict{String, Any}()

function _get_global(k)
    !haskey(_SYSTEM_GLOBALS, k) && error("global '$k' not set. To start a client uses `setup_gitsh` and to start a server use `run_server`")
    _SYSTEM_GLOBALS[k]
end

_has_global(k) = haskey(_SYSTEM_GLOBALS, k)

_get_url() = _get_global("url")
_set_url!(url) = (_SYSTEM_GLOBALS["url"] = url)

_get_root() = _get_global("root")
_set_root!(home) = (_SYSTEM_GLOBALS["root"] = home)