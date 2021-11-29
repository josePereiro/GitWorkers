# sys def root
const _GW_SYSTEM_DFLT_ROOT = homedir()

# depot dir
const _GW_DEPOT_NAME = ".gitworkers"
gw_depot_dir(sys_root::String) = joinpath(sys_root, _GW_DEPOT_NAME)
gw_depot_dir(gw::GitWorker) = gw_depot_dir(sys_root(gw))

# devland
const _GW_DEVLAND_FOLDER_NAME = ".devland"
gw_devland(sys_root::String) = joinpath(gw_depot_dir(sys_root), _GW_DEVLAND_FOLDER_NAME)

# worker_dir
_format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
worker_dir(gw::GitWorker) = joinpath(gw_depot_dir(gw), _format_url(remote_url(gw)))

# gitlink folder
const _GL_FOLDER_NAME = ".gitlink"
gitlink_dir(gw::GitWorker) = joinpath(worker_dir(gw), _GL_FOLDER_NAME)

# proc dir
const _GL_PROCS_FOLDER_NAME = ".gw-procs"
gw_procs_dir(gw::GitWorker) = joinpath(worker_dir(gw), _GL_PROCS_FOLDER_NAME)

# log dir
const _GL_LOGS_FOLDER_NAME = ".gw-logs"
gw_logs_dir(gw::GitWorker) = joinpath(worker_dir(gw), _GL_LOGS_FOLDER_NAME)

# tasks dir
const _GL_TASKS_FOLDER_NAME = ".gw-tasks"
gw_tasks_dir(gw::GitWorker) = joinpath(worker_dir(gw), _GL_TASKS_FOLDER_NAME)