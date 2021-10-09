const _GW_SERVER_MAIN_LOGGER = LoggingExtras.TeeLogger[]
const _GW_SERVER_MAIN_LOG_FILE_EXT = string("main", _GW_LOG_EXT)

_is_server_main_log_file(fn) = _endswith(fn, _GW_SERVER_MAIN_LOG_FILE_EXT)

function _get_server_main_logger()
    isempty(_GW_SERVER_MAIN_LOGGER) &&
        push!(
            _GW_SERVER_MAIN_LOGGER, 
            _tee_logger(_local_server_main_logs_dir(), "", _GW_SERVER_MAIN_LOG_FILE_EXT)
        )
    return first(_GW_SERVER_MAIN_LOGGER)
end

_with_server_main_logger(f::Function) = with_logger(f, _get_server_main_logger())

_last_server_main_logs(deep = 1) =
    _last_logs(_local_server_main_logs_dir(); deep, filter = _is_server_main_log_file)