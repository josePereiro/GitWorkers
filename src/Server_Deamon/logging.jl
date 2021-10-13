const _GW_SERVER_DEAMON_LOGGER = LoggingExtras.TeeLogger[]
const _GW_SERVER_DEAMON_LOG_FILE_EXT = string("deamon", _GW_LOG_EXT)

_is_server_deamon_log_file(fn) = _endswith(fn, _GW_SERVER_DEAMON_LOG_FILE_EXT)

function _get_server_deamon_logger()
    isempty(_GW_SERVER_DEAMON_LOGGER) &&
        push!(
            _GW_SERVER_DEAMON_LOGGER, 
            _tee_logger(_deamon_logs_dir(), "", _GW_SERVER_DEAMON_LOG_FILE_EXT)
        )
    return first(_GW_SERVER_DEAMON_LOGGER)
end

_with_server_deamon_logger(f::Function) = with_logger(f, _get_server_deamon_logger())

_last_server_deamon_logs(deep = 1) = 
    _last_logs(_deamon_logs_dir(); deep, filter = _is_server_deamon_log_file)