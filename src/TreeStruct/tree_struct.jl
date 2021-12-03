# devland
const _GW_DEVLAND_FOLDER_NAME = "devland"
gw_devland(sys_root::String) = joinpath(depot_dir(sys_root), _GW_DEVLAND_FOLDER_NAME)

# worker_dir
_format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
worker_dir(depodir::String, url::String) = joinpath(depodir, _format_url(url))
worker_dir(gw::GitWorker) = worker_dir(depot_dir(gw), remote_url(gw))
worker_relpath(gw::GitWorker, path) = _relbasepath(path, worker_dir(gw))
worker_abspath(gw::GitWorker, path) = joinpath(worker_dir(gw), worker_relpath(gw, path))

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