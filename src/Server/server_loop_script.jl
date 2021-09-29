import GitWorkers

## ------------------------------------------------------------------
# args
sys_root = ARGS[1]
url = ARGS[2]

## ------------------------------------------------------------------
GitWorkers._setup_gitworker_local_part(;url, sys_root)

## ------------------------------------------------------------------
# OS
GitWorkers._reg_server_loop_proc()
@async while true
    # REG PROC
    GitWorkers._reg_server_loop_proc()
    sleep(10.0)
end

## ------------------------------------------------------------------
GitWorkers._server_loop()