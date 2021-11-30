const _GW_DFLT_TASK_VTIME = 120.0

const _GW_STAGING_TOUT = 60.0

function _upload_jltask(gw::GitWorker,
        tid::String, ex::Expr;
        desc = "", src = _expr_src(ex),
        readme = false,
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
        tdict[_GW_TASK_DESC_KEY] = desc
        _write_toml(tfile, tdict)

        # dat.jls
        dat_file = _taskdat_file(taskdir)
        tdat_dict = Dict{String, Any}()
        tdat_dict[_GW_TASK_EXPR_KEY] = ex
        tdat_dict[_GW_TASK_SRC_KEY] = src
        serialize(dat_file, tdat_dict)

        # README.md
        if readme
            _gen_readme(taskdir::String)
        end
        
    end # writewdir
end