const _GW_TASK_FILE_NAME = "task.toml"
const _GW_TASK_RUNME_FILE_NAME = "runme.jl"
const _GW_TASK_EXPR_FILE_NAME = "expr.jls"
const _GW_TASK_README_FILE_NAME = "README.md"

_task_file(taskdir::String) = joinpath(taskdir, _GW_TASK_FILE_NAME)
_runme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_RUNME_FILE_NAME)
_expr_file(taskdir::String) = joinpath(taskdir, _GW_TASK_EXPR_FILE_NAME)
_readme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_README_FILE_NAME)

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

const _GW_STAGING_TOUT = 60.0

function _upload_jltask(gw::GitWorker,
        tid::String, ex::Expr;
        readme = "",
        vtime = _GW_DFLT_TASK_VTIME
    )

    tout = _GW_STAGING_TOUT
    gl = gitlink(gw)
    
    return GitLinks.writewdir(gl; tout) do _

        # task dir
        taskdir = gw_task_dir(gw, tid)
        taskdir = gw_repo_mirpath(gw, taskdir)
        @show taskdir
        mkpath(taskdir)

        # create runme.jl
        runfile = _runme_file(taskdir)
        runsrc = string(
            "# Run this file using julia\n",
            "# Ex: julia runme.jl\n",
            "import GitWorkers\n",
            "GitWorkers._runme(@__DIR__, ARGS)\n",
        )
        write(runfile, runsrc)
                
        # task.toml
        tfile = _task_file(taskdir)
        tdict = Dict{String, Any}()
        tdict[_GW_TASK_TID_KEY] = tid
        tdict[_GW_TASK_EXPTIME_KEY] = time() + vtime
        tdict[_GW_TASK_RUNSTATE_KEY] = _GW_TASK_PENDING_RUNSTATE
        _write_toml(tfile, tdict)

        # expr.jls
        expr_file = _expr_file(taskdir)
        serialize(expr_file, ex)

        # README.md
        if !isempty(readme)
            mdfile = _readme_file(taskdir)
            write(mdfile, readme)
        end
        
    end # writewdir
end