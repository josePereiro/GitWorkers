using GitWorkers

## ---------------------------------------------------------------
# cmd for running the server (run in different process)
# julia --project '__SERVER_SCRIPT_PATH__'

## ---------------------------------------------------------------
run_gitworker_server(;
    sys_root = "SERVER_ROOT",
    url = "__REMOTE_URL__"
)

## ---------------------------------------------------------------
# DONE
exit()