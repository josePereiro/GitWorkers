"""
    This function will set a given task (or path ownertask) as executable.
    Then will push_as_master
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

    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME)


    if !deb
        verbose && println()
        verbose && println("------------------ PULLING ORIGIN -----------------")
        verbose && println()
        git_pull(force = true, print = verbose)
    end

    verbose &&println()
    verbose &&println("------------------ PREPARING TASK -----------------")

    # Updating control dicts
    global ORIGIN_CONFIG = read_config(worker)
    global LOCAL_STATUS = read_status(worker)
    info = "Master order: execute task!!"

    # Kill sign to not kill
    set_config(NOT_KILL_SIGN, taskname, KILL_SIGN_KEY, VALUE_KEY)
    set_config(info, taskname, KILL_SIGN_KEY, INFO_KEY)
    set_config(now(), taskname, KILL_SIGN_KEY, UPDATE_DATE_KEY)

    # exec_order
    last_exec_order = get_status(taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)
    last_exec_order = isnothing(last_exec_order) ? 
        DEFAULT_LAST_EXEC_ORDER : last_exec_order
    exec_order = get_config(taskname, EXEC_ORDER_KEY, VALUE_KEY)
    exec_order = isnothing(exec_order) ? 
        DEFAULT_EXEC_ORDER : exec_order
    exec_order = max(exec_order, last_exec_order) + 1
    last_exec_order = exec_order - 1
    set_config(exec_order, taskname, EXEC_ORDER_KEY, VALUE_KEY)
    set_config(info, taskname, EXEC_ORDER_KEY, INFO_KEY)
    set_config(now(), taskname, EXEC_ORDER_KEY, UPDATE_DATE_KEY)

    # push token
    set_config(push_token, PUSH_TOKEN_KEY, VALUE_KEY)
    set_config(info, PUSH_TOKEN_KEY, INFO_KEY)
    set_config(now(), PUSH_TOKEN_KEY, UPDATE_DATE_KEY)
    
    verbose && summary_task(taskname)

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)
    write_config(ORIGIN_CONFIG, path; create = true)

    if !deb
        verbose && println()
        verbose && println("------------------ PUSHING MASTER -----------------")
        verbose && println()

        # TODO: introduce checks before pushing
        # ------------------- PUSH ORIGINS -------------------
        git_add_all(print = verbose)
        commit_msg = isnothing(commit_msg) ? "Master to $(workername): exec $(taskname)" : commit_msg
        git_commit(commit_msg, print = verbose)
        git_push(force = true, print = verbose)
    end

    verbose && println()
    verbose && println("------------------ READING LOGS -----------------")
    verbose && println()
    !deb && follow && follow_exec(exec_order, taskroot, init_margin = 0)

    return nothing
end