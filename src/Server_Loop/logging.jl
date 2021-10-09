const _GW_SERVER_LOOP_LOGGER = _tee_logger(_local_tasks_outs_dir(), "", "server_loop.log")

with_server_logger(f::function) = with_logger(f)