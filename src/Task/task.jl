const _GW_TASK_FILE_NAME = "task.toml"
const _GW_TASK_RUNME_FILE_NAME = "runme.jl"
const _GW_TASK_EXPR_FILE_NAME = "expr.jls"

_task_file(taskdir::String) = joinpath(taskdir, _GW_TASK_FILE_NAME)
_runme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_RUNME_FILE_NAME)
_expr_file(taskdir::String) = joinpath(taskdir, _GW_TASK_EXPR_FILE_NAME)

function _task_id(tname)
    _date = Dates.now()
    tstr = Dates.format(_date, "yyyy-mm-dd-HHMMSS")
    return isempty(tname) ? tstr : string(tstr, "-", tname)
end

const _GW_DFLT_TASK_VTIME = 120.0

const _GW_TASK_TID_KEY = "tid"
const _GW_TASK_EXPTIME_KEY = "exptime"
const _GW_TASK_RUNSTATE_KEY = "runstate"

const _GW_TASK_PENDING_RUNSTATE = "pending"
const _GW_TASK_RUNNING_RUNSTATE = "running"
const _GW_TASK_DONE_RUNSTATE = "done"
const _GW_TASK_ERROR_RUNSTATE = "error"

function _stage_jltask(gw::GitWorker,
        tid::String, ex::Expr;
        desc = "",
        full_readme = true,
        vtime = _GW_DFLT_TASK_VTIME
    )

    # task dir
    taskdir = gw_task_dir(gw, tid)
    taskdir = gw_stage_mirpath(gw, path)

    # create runme.jl
    runfile = _runme_file(taskdir)
    
    # task.toml
    tfile = _task_file(taskdir)
    tdict = Dict{String, Any}()
    tdict[_GW_TASK_TID_KEY] = tid
    tdict[_GW_TASK_EXPTIME_KEY] = time() + vtime

    

end