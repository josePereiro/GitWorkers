import GitWorkers

## ------------------------------------------------------------------
GitWorkers._local_setup(;
    sys_root = ARGS[1],
    url = ARGS[2]
)

## ------------------------------------------------------------------
GitWorkers._server_loop()