const _GW_TASK_RUNME_FILE_NAME = "runme.jl"
_runme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_RUNME_FILE_NAME)
_runme_file(gwt::GWTask) = _runme_file(task_dir(gwt))

## ------------------------------------------------------
function _write_runme(gwt::GWTask)
    rfile = _runme_file(gwt)
    write(rfile, 
        string(
            "",
        )
    )
end

## ------------------------------------------------------
function _resolve_gwtask(taskdir)
    gwtfile = _task_file(taskdir)
    tid = get(_read_toml(gwtfile), _GW_TASK_TID_KEY, "")
    return isempty(tid) ? 
        GWTask(basename(task_dir), taskdir) : 
        GWTask(tid, taskdir)
end

## ------------------------------------------------------
# runme
const _GW_TASK_OS_UPFREC = 5.0

function _runme(taskdir::String, args::Vector)

    @eval begin

        # TODO: activate a temp env
        # A copy of a pre-generated one

        ## ------------------------------------------------------
        const __GWM = GitWorkers

        ## ------------------------------------------------------
        # GWTASK
        const __GW_TASK_DIR = $(taskdir)
        const __GWT = __GWM._resolve_gwtask(__GW_TASK_DIR)

        ## ------------------------------------------------------
        # HASNDLE FlAGS
        const __ARGS = $(args)
        __GWM._parse_args!(__GWT, __ARGS)

        ## ------------------------------------------------------
        # WORKER MODE (RUNNING UNDER A WORKER PROCESS)
        if is_worker_mode(gwt)

            # TODO: move to sys_root
            root = sys_root(gitworking(gwt))

            _read_task_toml!(gwt)

            # read task.toml
            GitWorkers._fatal_err() do
                !isfile(__GW_TASK_FILE) && error("FATAL ERROR: task file not found at: '$(__GW_TASK_FILE)'")
                
                # load
                merge!(__GW_TASK_DAT, GitWorkers._read_toml(__GW_TASK_FILE))
            end

            const __GW_TASKID = get(__GW_TASK_DAT, GitWorkers._GW_TASK_TID_KEY, "")
            const __GW_EXTIME = get(__GW_TASK_DAT, GitWorkers._GW_TASK_EXPTIME_KEY, -1.0)
            __GW_RUNSTATE = get(__GW_TASK_DAT, GitWorkers._GW_TASK_RUNSTATE_KEY, GitWorkers._GW_TASK_RUNNING_RUNSTATE)

            # runstate util
            function __up_runstate()
                __GW_TASK_DAT[GitWorkers._GW_TASK_RUNSTATE_KEY] = __GW_RUNSTATE
                GitWorkers._mkdir(__GW_TASK_FILE)
                GitWorkers._write_toml(__GW_TASK_FILE, __GW_TASK_DAT)
            end

            # write runstate at exit
            atexit(__up_runstate)

            # some save checking
            GitWorkers._fatal_err() do
                isempty(__GW_TASKID) && error("FATAL ERROR: task file not well formed: '$(__GW_TASK_FILE)'")
                __GW_EXTIME < time() && error("FATAL ERROR: the task order has expired!!!")
                if (__GW_RUNSTATE != GitWorkers._GW_TASK_PENDING_RUNSTATE) 
                    _OLD_STATUS = __GW_RUNSTATE
                    __GW_RUNSTATE = GitWorkers._GW_TASK_ERROR_RUNSTATE
                    error("FATAL ERROR: task run status = '$(_OLD_STATUS)'. Needs to be '$(GitWorkers._GW_TASK_PENDING_RUNSTATE)'")
                end
                # label runstate as running
                __GW_RUNSTATE = GitWorkers._GW_TASK_RUNNING_RUNSTATE
                __up_runstate()
            end
    
            # read gitworker.toml
            const __GW_WORKER_FILE = GitWorkers._find_worker_file(__GW_TASK_DIR)
            const __GW_WORKER_DAT = Dict{String, Any}()
            
            GitWorkers._fatal_err() do
                !isfile(__GW_WORKER_FILE) && error("FATAL ERROR: task file not found at")
                # load
                merge!(__GW_WORKER_DAT, GitWorkers._read_toml(__GW_WORKER_FILE))
            end

            const __GW_SYS_ROOT = get(__GW_TASK_DAT, GitWorkers._GW_WORKER_FILE_SYSROOT_KEY, "")
            const __GW_REMOTE_URL = get(__GW_TASK_DAT, GitWorkers._GW_WORKER_FILE_REMOTE_URL_KEY, "")

            GitWorkers._fatal_err() do
                (isempty(__GW_SYS_ROOT) || isempty(__GW_REMOTE_URL)) && 
                    error("FATAL ERROR: worker data missing. Check: '$(__GW_WORKER_FILE)'")
            end

            const __GW = GitWorkers.GitWorker(;
                sys_root = __GW_SYS_ROOT,
                remote_url = __GW_REMOTE_URL
            )
            GitWorkers.gw_curr(__GW)

        end # if __WORKER_FLAG

        ## ------------------------------------------------------
        # WELCOME
        println("-"^60)
        println("Hi from: ", __GW_TASKID)
        println("\n")
        GitWorkers._flush()

        ## ------------------------------------------------------
        # TASK OS
        if __WORKER_FLAG
            @async begin
                 while true
                    GitWorkers._flush()
                    sleep(GitWorkers._GW_TASK_OS_UPFREC)
                end
            end
        end

        ## ------------------------------------------------------
        # RUN EXPR
        _fatal_err() do
            __GW_TASKDAT_FILE = __GWM._taskdat_file(__GWT)
            !isfile(__GW_TASKDAT_FILE) && error("FATAL ERROR: task expr file not found at: '$(__GW_TASKDAT_FILE)'")
            __GW_TASKDAT = deserialize(__GW_TASKDAT_FILE)
            !haskey(__GW_EXPR, GitWorkers._GW_TASK_EXPR_KEY) && error("FATAL ERROR: expr object missing!")
            __GW_EXPR = __GW_TASKDAT[GitWorkers._GW_TASK_EXPR_KEY]
            eval(__GW_EXPR) # run
            GitWorkers._flush()
        end

        ## ------------------------------------------------------
        # label runstate as done
        if __WORKER_FLAG
            __GW_RUNSTATE = GitWorkers._GW_TASK_DONE_RUNSTATE
            __up_runstate()
        end

        ## ------------------------------------------------------
        # SAY GOOD BY
        println("-"^60)
        println("Bye from: ", __GW_TASKID)
        println("\n")

        ## ------------------------------------------------------
        # flush like a crazy
        for _ in 1:5
            GitWorkers._flush()
            sleep(0.05)
        end

        ## ------------------------------------------------------
        # EXIT
        exit()
    end # @eval begin
end