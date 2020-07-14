"""
    This function will set a given task (or path ownertask) as executable.
    Then will master_update
"""
function exec_task(path = pwd(); 
    commit_msg = nothing,
    verbose = true, deb = false, 
    follow = true, push_token = follow)

    worker = path |> find_ownerworker
    workername = worker |> get_workername
    ownertask = path |> find_ownertask
    taskroot = ownertask |> get_taskroot
    taskname = ownertask |> get_taskname

    master_update(worker; deb = deb, verbose = verbose,

        commit_msg = isnothing(commit_msg) ? "Master to $(workername): exec $(taskname)" : commit_msg,

        before_push = function(worker)
            
            info = "Master order: execute task!!"

             # push token
             set_config(push_token, PUSH_TOKEN_KEY, VALUE_KEY)
             set_config(info, PUSH_TOKEN_KEY, INFO_KEY)
             set_config(now(), PUSH_TOKEN_KEY, UPDATE_DATE_KEY)

            verbose && println()
            verbose && println("------------------ PUSH TOKEN -----------------")
            verbose && pretty_print(Dict(PUSH_TOKEN_KEY => get_config(PUSH_TOKEN_KEY)))
            verbose && println()

            verbose && println()
            verbose && println("------------------ PREPARING TASK -----------------")

            # Kill sign to not kill
            set_config(NOT_KILL_SIGN, taskname, KILL_SIGN_KEY, VALUE_KEY)
            set_config(info, taskname, KILL_SIGN_KEY, INFO_KEY)
            set_config(now(), taskname, KILL_SIGN_KEY, UPDATE_DATE_KEY)

            # exec_order
            last_exec_order = get_status(taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY; default = DEFAULT_LAST_EXEC_ORDER)
            exec_order = get_config(taskname, EXEC_ORDER_KEY, VALUE_KEY; default = DEFAULT_EXEC_ORDER)
            exec_order = max(exec_order, last_exec_order) + 1
            last_exec_order = exec_order - 1
            set_config(exec_order, taskname, EXEC_ORDER_KEY, VALUE_KEY)
            set_config(info, taskname, EXEC_ORDER_KEY, INFO_KEY)
            set_config(now(), taskname, EXEC_ORDER_KEY, UPDATE_DATE_KEY)
            
            verbose && summary_task(taskname)

        end
    )

    verbose && println()
    verbose && println("------------------ READING LOGS -----------------")
    verbose && println()
    exec_order = get_config(taskname, EXEC_ORDER_KEY, VALUE_KEY)
    !deb && follow && follow_exec(exec_order, taskroot; init_margin = 0)

end
