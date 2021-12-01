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
const _GW_TASK_RUNSTATE_KEY = "runstate"
const _GW_TASK_PENDING_RUNSTATE = "pending"
const _GW_TASK_RUNNING_RUNSTATE = "running"
const _GW_TASK_DONE_RUNSTATE = "done"
const _GW_TASK_ERROR_RUNSTATE = "error"
const _GW_TASK_UNKNOWN_RUNSTATE = "unknown"

_task_toml(gwt::GWTask) = get!(gwt, _GW_TASK_FILE_NAME) do
    Dict{String, Any}(
        _GW_TASK_TID_KEY => task_id(gwt)
    )
end

function _write_task_toml!(gwt::GWTask; 
        vtime = _GW_TASK_TID_KEY, 
        status = _GW_TASK_PENDING_RUNSTATE, 
        desc = ""
    )

    toml = _task_toml(gwt)
    toml[_GW_TASK_EXPTIME_KEY] = time() + vtime
    toml[_GW_TASK_RUNSTATE_KEY] = status
    toml[_GW_TASK_DESC_KEY] = desc

    tfile = _task_file(gwt)
    _write_toml(tfile, toml)

    return toml
end

function _read_task_toml!(gwt::GWTask)
    tfile = _task_file(gwt)
    toml = _read_toml(tfile)
    merge!(_task_toml(gwt), toml)
    return toml
end

function _get_task_status(gwt::GWTask)
    toml = _task_toml(gwt)
    get!(toml, _GW_TASK_RUNSTATE_KEY, _GW_TASK_UNKNOWN_RUNSTATE)
end

function _get_task_extime(gwt::GWTask)
    toml = _task_toml(gwt)
    get!(toml, _GW_TASK_EXPTIME_KEY, -1.0)
end