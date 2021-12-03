# sys def root
const _GW_SYSTEM_DFLT_ROOT = homedir()

# depot dir
const _GW_DEPOT_NAME = ".gitworkers"
gw_depot_dir(sys_root::String) = joinpath(sys_root, _GW_DEPOT_NAME)
gw_depot_dir(gw::GitWorker) = gw_depot_dir(sys_root(gw))

# deamon dir
const _GW_DEAMON_FOLDER_NAME = "gwdeamon"
gw_deamon_dir(sys_root::String) = joinpath(sys_root, _GW_DEAMON_FOLDER_NAME)
gw_deamon_dir(gw::GitWorker) = gw_deamon_dir(sys_root(gw))

# devland
const _GW_DEVLAND_FOLDER_NAME = "devland"
gw_devland(sys_root::String) = joinpath(gw_depot_dir(sys_root), _GW_DEVLAND_FOLDER_NAME)

# worker_dir
_format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
worker_dir(depodir::String, url::String) = joinpath(depodir, _format_url(url))
worker_dir(gw::GitWorker) = worker_dir(gw_depot_dir(gw), remote_url(gw))
worker_relpath(gw::GitWorker, path) = _relbasepath(path, worker_dir(gw))
worker_abspath(gw::GitWorker, path) = joinpath(worker_dir(gw), worker_relpath(gw, path))

# procs dir
const _GL_PROCS_FOLDER_NAME = "procs"
_procs_dir(dir::String) = joinpath(dir, _GL_PROCS_FOLDER_NAME)
gw_procs_dir(gw::GitWorker) = _procs_dir(worker_dir(gw))
dm_procs_dir(dmdir::String) = _procs_dir(dmdir)

# log dir
const _GL_LOGS_FOLDER_NAME = "logs"
_logs_dir(dir::String) = joinpath(dir, _GL_LOGS_FOLDER_NAME)
gw_logs_dir(gw::GitWorker) = _logs_dir(worker_dir(gw)s)
dm_logs_dir(dmdir::String) = _logs_dir(dmdir)

# tasks dir
const _GL_TASKS_FOLDER_NAME = "tasks"
gw_tasks_dir(gw::GitWorker) = joinpath(worker_dir(gw), _GL_TASKS_FOLDER_NAME)
gw_task_dir(gw::GitWorker, tid::String) = joinpath(gw_tasks_dir(gw), tid)

# gitlink folder
const _GL_FOLDER_NAME = ".gitlink"
gitlink_dir(gw::GitWorker) = joinpath(worker_dir(gw), _GL_FOLDER_NAME)

# repo_dir
import GitLinks.repo_dir
repo_dir(gw::GitWorker) = repo_dir(gitlink(gw))

# stage_dir
import GitLinks.stage_dir
stage_dir(gw::GitWorker) = stage_dir(gitlink(gw))

# repo version
function gw_repo_mirpath(gw::GitWorker, path::String)
    wrpath = worker_relpath(gw, path)
    return joinpath(repo_dir(gw), wrpath)
end

# stage version
function gw_stage_mirpath(gw::GitWorker, path::String)
    wrpath = worker_relpath(gw, path)
    return joinpath(stage_dir(gw), wrpath)
end