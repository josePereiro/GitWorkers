# TODO: eliminate sys_root (it is only use for computing the depot_root)

# worker_root
worker_root(w::AbstractWorker) = w.worker_root

# relpath
import Base.relpath
relpath(w::AbstractWorker, path::String) = _relbasepath(path, worker_root(w))

# abspath
import Base.abspath
abspath(w::AbstractWorker, path::String) = joinpath(worker_root(w), relpath(w, path))

import Base.mkpath
mkpath(w::AbstractWorker) = mkpath(worker_root(w))

# procs dir
const _GL_PROCS_FOLDER_NAME = "procs"
_procs_dir(dir::String) = joinpath(dir, _GL_PROCS_FOLDER_NAME)
procs_dir(w::AbstractWorker) = _procs_dir(worker_root(w))

# logs dir
const _GL_LOGS_FOLDER_NAME = "logs"
_logs_dir(dir::String) = joinpath(dir, _GL_LOGS_FOLDER_NAME)
logs_dir(w::AbstractWorker) = _logs_dir(worker_root(w))
