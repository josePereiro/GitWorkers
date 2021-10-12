import GitWorkers

## ------------------------------------------------------------------
GitWorkers._local_setup(;
    sys_root = ARGS[1],
    url = ARGS[2]
)

## ------------------------------------------------------------------
GitWorkers._with_server_loop_logger() do
    GitWorkers._server_loop()
end