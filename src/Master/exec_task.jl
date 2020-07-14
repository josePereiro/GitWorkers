"""
    This function will set a given task (or path ownertask) as executable.
    Then will push_master
"""
function exec_task(path = pwd(); 
        commit_msg = get_workername(path) * " master update",
        verbose = true,
        deb = false)
    worker = find_ownerworker(path)
    ownertask = find_ownertask(path)
    taskroot = ownertask |> get_taskroot
    taskname = ownertask |> get_taskname

    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME)


    verbose && println()
    verbose && println("------------------ PULLING ORIGIN -----------------")
    verbose && println()
    !deb && git_pull(force = true, print = verbose)

    verbose &&println()
    verbose &&println("------------------ PREPARING TASK -----------------")

    # Updating control dicts
    global ORIGIN_CONFIG = read_config(worker)
    global LOCAL_STATUS = read_status(worker)
    info = "Master order, execute task"

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
    # set_status(false, taskname, EXEC_STATUS_KEY, VALUE_KEY)
    # set_status(info, taskname, EXEC_STATUS_KEY, INFO_KEY)
    # set_status(now(), taskname, EXEC_STATUS_KEY, UPDATE_DATE_KEY)
    # set_status(last_exec_order, taskname, EXEC_STATUS_KEY, LAST_EXEC_ORDER_KEY)

    verbose && summary_task(taskname)

    verbose && println()
    verbose && println("------------------ PUSHING MASTER -----------------")
    verbose && println()

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)

    # writing
    write_config(ORIGIN_CONFIG, path; create = true)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    !deb && git_add_all(print = verbose)
    !deb && git_commit(commit_msg, print = verbose)
    !deb && git_push(force = true, print = verbose)

    verbose && println()
    verbose && println("------------------ READING LOGS -----------------")
    verbose && println()
    !deb && follow_exec(exec_order, taskroot, init_margin = 0)

    return nothing
end