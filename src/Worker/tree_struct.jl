# depot path
depot_dir(gw::GitWorker) = _depot_dir(sys_root(gw))

# worker_root
_format_url(url::String) = replace(url, r"[^a-zA-Z0-9-_]"=> "_")
_url_dir(depodir::String, url::String) = joinpath(depodir, _format_url(url))

# gitlink folder
const _GL_FOLDER_NAME = ".gitlink"
gitlink_dir(gw::GitWorker) = joinpath(worker_root(gw), _GL_FOLDER_NAME)

# repo_dir
import GitLinks.repo_dir
repo_dir(gw::GitWorker) = repo_dir(gitlink(gw))

# stage_dir
import GitLinks.stage_dir
stage_dir(gw::GitWorker) = stage_dir(gitlink(gw))

# tasks dir
const _GL_TASKS_FOLDER_NAME = "tasks"
tasks_dir(gw::GitWorker) = joinpath(worker_root(gw), _GL_TASKS_FOLDER_NAME)

# repo version
function repo_mirpath(gw::GitWorker, path::String)
    wrpath = relpath(gw, path)
    return joinpath(repo_dir(gw), wrpath)
end

# stage version
function stage_mirpath(gw::GitWorker, path::String)
    wrpath = relpath(gw, path)
    return joinpath(stage_dir(gw), wrpath)
end