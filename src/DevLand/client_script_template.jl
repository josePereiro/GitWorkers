using GitWorkers

## ---------------------------------------------------------------
# cmd for run the server
# julia '__SERVER_SCRIPT_PATH__'

## ---------------------------------------------------------------
# run to reset all
# gw_create_devland(;
#     sys_root = "__SYS_ROOT__",
#     remote_url = "__REMOTE_URL__",
#     clear_repos = true, 
#     clear_scripts = false,
#     verbose = false
# )

## ---------------------------------------------------------------
gw_setup(;
    sys_root = "__CLIENT_ROOT__",
    url = "__REMOTE_URL__",
)

## ---------------------------------------------------------------
# Make your stuff here
