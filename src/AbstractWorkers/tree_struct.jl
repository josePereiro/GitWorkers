# rootdir
rootdir(w::AbstractWorker) = w.rootdir

# relpath
Base.relpath
relpath(w::AbstractWorker, path::String) = _relbasepath(path, rootdir(w))

# procs dir
const _GL_PROCS_FOLDER_NAME = "procs"
_procs_dir(dir::String) = joinpath(dir, _GL_PROCS_FOLDER_NAME)
procs_dir(w::AbstractWorker) = _procs_dir(rootdir(w))

# logs dir
const _GL_LOGS_FOLDER_NAME = "logs"
_logs_dir(dir::String) = joinpath(dir, _GL_LOGS_FOLDER_NAME)
logs_dir(w::AbstractWorker) = _logs_dir(rootdir(w))
