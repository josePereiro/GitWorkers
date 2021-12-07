const _GW_TASK_RUNME_FILE_NAME = "runme.jl"
_runme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_RUNME_FILE_NAME)
_runme_file(gwt::GWTask) = _runme_file(task_dir(gwt))

## ------------------------------------------------------
function _write_runme(gwt::GWTask)
    rfile = _runme_file(gwt)
    write(rfile, 
        string(
            "# It is the responsibility of the caller to use an appropriate environment", "\n",
            "import GitWorkers", "\n",
            "GitWorkers._runme(@__DIR__)",
        )
    )
end

## ------------------------------------------------------
# runme

function _runme(taskdir::String)

    @eval begin

        # TODO: activate a temp env
        # A copy of a pre-generated one

        ## ------------------------------------------------------
        const __GWM = GitWorkers

        ## ------------------------------------------------------
        # GWTASK
        const __GW_TASK_DIR = $(taskdir)
        const __GWT = __GWM._load_task(__GW_TASK_DIR)

        ## ------------------------------------------------------
        # HANDLE FlAGS
        __GWM._parse_args!(__GWT, ARGS)

        ## ------------------------------------------------------
        # MOVE TO HOMEDIR
        cd(homedir())

        ## ------------------------------------------------------
        # WELCOME
        __GWM._print_welcome(__GWT)

        ## ------------------------------------------------------
        # TASK STATUS
        @async __GWM._run_task_os(__GWT)
        
        ## ------------------------------------------------------
        # RUN EXPR
        __GWM._fatal_err(__GWT) do
            __GWM._read_task_dat!(__GWT)
            __GW_EXPR = _task_expr(__GWT)
            isnothing(__GW_EXPR) && error("FATAL ERROR: expr object missing!")
            eval(__GW_EXPR) # run
            __GWM._flush_all()
        end

        ## ------------------------------------------------------
        # LABEL AS DONE
        _up_task_status(__GWT, _GW_TASK_DONE_STATUS)

        ## ------------------------------------------------------
        # SAY GOOD BY
        __GWM._print_eotask(__GWT)

        ## ------------------------------------------------------
        # flush like a crazy
        for _ in 1:5
            __GWM._flush_all()
            sleep(0.05)
        end

        ## ------------------------------------------------------
        # EXIT
        exit()
    end # @eval begin
end