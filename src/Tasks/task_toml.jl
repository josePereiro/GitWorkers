# task file
const _GW_TASK_FILE_NAME = "task.toml"
_task_file(taskdir::String) = joinpath(taskdir, _GW_TASK_FILE_NAME)
_task_file(gwt::GWTask) = _task_file(task_dir(gwt))

# tid
const _GW_TASK_TID_KEY = "tid"

# exptime
const _GW_TASK_EXPTIME_KEY = "exptime"
const _GW_DFLT_TASK_VTIME = 120.0

# status
const _GW_TASK_STATUS_KEY = "runstate"
const _GW_TASK_PENDING_STATUS = "pending"
const _GW_TASK_SPAWNED_STATUS = "spawned"
const _GW_TASK_RUNNING_STATUS = "running"
const _GW_TASK_DONE_STATUS = "done"
const _GW_TASK_ERROR_STATUS = "error"
const _GW_TASK_UNKNOWN_STATUS = "unknown"

function _write_task_toml(gwt::GWTask; 
        extime = _GW_TASK_TID_KEY, 
        status = _GW_TASK_PENDING_STATUS, 
        desc = ""
    )

    toml = Dict{String, Any}()
    toml[_GW_TASK_EXPTIME_KEY] = extime
    toml[_GW_TASK_STATUS_KEY] = status
    toml[_GW_TASK_DESC_KEY] = desc

    tfile = _task_file(gwt)
    _write_toml(tfile, toml)

    return toml
end

function _read_task_toml(gwt::GWTask)
    tfile = _task_file(gwt)
    toml = _read_toml(tfile)
    return toml
end

function _get_task_status(gwt::GWTask)
    toml = _read_task_toml(gwt)
    get!(toml, _GW_TASK_STATUS_KEY, _GW_TASK_UNKNOWN_STATUS)
end

function _up_task_status(gwt::GWTask, status)
    toml = _read_task_toml(gwt)
    toml[_GW_TASK_STATUS_KEY] = status
    _write_toml(_task_file(gwt), toml)
end

_is_pending_task(gwt::GWTask) = (_get_task_status(gwt) == _GW_TASK_PENDING_STATUS)
_is_spawned_task(gwt::GWTask) = (_get_task_status(gwt) == _GW_TASK_SPAWNED_STATUS)

function _get_task_extime(gwt::GWTask)
    toml = _read_task_toml(gwt)
    get!(toml, _GW_TASK_EXPTIME_KEY, -1.0)
end

function _load_task(taskdir)
    gwtfile = _task_file(taskdir)
    tid = get(_read_toml(gwtfile), _GW_TASK_TID_KEY, "")
    return isempty(tid) ? 
        GWTask(basename(taskdir), taskdir) : 
        GWTask(tid, taskdir)
end