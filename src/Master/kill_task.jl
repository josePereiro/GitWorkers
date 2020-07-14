function kill_task(path = pwd();
        commit_msg = nothing,
        verbose = true, deb = false, 
        follow = true, push_token = follow)

    # checks
    check_gitignores(path)

    worker = path |> find_ownerworker
    workername = worker |> get_workername
    ownertask = path |> find_ownertask
    taskroot = ownertask |> get_taskroot
    taskname = ownertask |> get_taskname

    master_update(worker; deb = deb, verbose = verbose,

        commit_msg = isnothing(commit_msg) ? "Master to $(workername): kill $(taskname)" : commit_msg,

        before_push = function(worker)

            info = "Master kill"
            set_config(KILL_SIGN, taskname, KILL_SIGN_KEY, VALUE_KEY)
            set_config(info, taskname, KILL_SIGN_KEY, INFO_KEY)
            set_config(now(), taskname, KILL_SIGN_KEY, UPDATE_DATE_KEY)

        end

    )

    verbose && print_title("READING LOGS")
    exec_order = get_config(taskname, EXEC_ORDER_KEY, VALUE_KEY)
    !deb && follow && follow_exec(exec_order, taskroot; init_margin = 0)

end