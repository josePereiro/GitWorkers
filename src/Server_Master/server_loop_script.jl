import GitWorkers

## ------------------------------------------------------------------
GitWorkers._gw_setup_client_local_part(;
    sys_root = ARGS[1],
    url = ARGS[2]
)

## ------------------------------------------------------------------
GitWorkers._server_loop()