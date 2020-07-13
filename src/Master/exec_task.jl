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
    verbose &&println("task: ", taskname)

    # Updating control dicts
    global ORIGIN_CONFIG = read_origin_config(worker)
    global LOCAL_STATUS = read_local_status(worker)

    verbose && summary_task(taskname)

    # Kill sign to not kill
    set_kill_sign(taskname, KILL_SIGN_KEY; info = "Prepare for task execution")

    # exec_order
    last_exec_order = get_exec_status(taskname, LAST_EXEC_ORDER_KEY)
    last_exec_order = isnothing(last_exec_order) ? 
        DEFAULT_LAST_EXEC_ORDER : last_exec_order
    exec_order = get_exec_order(taskname)
    exec_order = isnothing(exec_order) ? 
        DEFAULT_EXEC_ORDER : exec_order
    exec_order = max(exec_order, last_exec_order) + 1
    last_exec_order = exec_order - 1
    set_exec_order(taskname, exec_order)
    set_exec_status(taskname, false, last_exec_order)

    verbose && println("new exec order: $exec_order")

    verbose && println()
    verbose && println("------------------ PUSHING MASTER -----------------")
    verbose && println()

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)

    # writing
    write_origin_config(ORIGIN_CONFIG, path; create = true)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    !deb && git_add_all(print = verbose)
    !deb && git_commit(commit_msg, print = verbose)
    !deb && git_push(force = true, print = verbose)

    verbose && println()
    verbose && println("------------------ READING LOGS -----------------")
    verbose && println()
    follow_exec(exec_order, taskroot, init_margin = 0)

end