const _GW_SERVER_LOOP_LOGGER = LoggingExtras.TeeLogger[]
const _GW_SERVER_LOOP_LOG_FILE_EXT = string("loop", _GW_LOG_EXT)

_is_server_loop_log_file(fn) = _endswith(fn, _GW_SERVER_LOOP_LOG_FILE_EXT)

function _get_server_loop_logger()
    isempty(_GW_SERVER_LOOP_LOGGER) &&
        push!(
            _GW_SERVER_LOOP_LOGGER, 
            _tee_logger(_local_server_loop_logs_dir(), "", _GW_SERVER_LOOP_LOG_FILE_EXT)
        )
    return first(_GW_SERVER_LOOP_LOGGER)
end

_with_server_loop_logger(f::Function) = with_logger(f, _get_server_loop_logger())

_last_server_loop_logs(deep = 1) = 
    _last_logs(_local_server_loop_logs_dir(); deep, filter = _is_server_loop_log_file)