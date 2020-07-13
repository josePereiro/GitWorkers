"""
    This function will set a given task (or path ownertask) as executable.
    Then will push_master
"""
function exec_task(path = pwd(); 
        commit_msg = get_workername(path) * " master update",
        deb = false)
    worker = find_ownerworker(path)
    ownertask = find_ownertask(path)
    taskroot = ownertask |> get_taskroot
    taskname = ownertask |> get_taskname

    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME)


    println()
    println("------------------ PULLING ORIGIN -----------------")
    println()
    !deb && git_pull(force = true, print = true)

    println()
    println("------------------ PREPARING TASK -----------------")
    println("task: ", taskname)

    # Updating control dicts
    global ORIGIN_CONFIG = read_origin_config(worker)
    global LOCAL_STATUS = read_local_status(worker)

    summary_task(taskname)

    # Kill sign to not kill
    set_kill_sign(taskname, KILL_SIGN_KEY; info = "Prepare for task execution")

    # exec_order
    @show last_exec_order = get_exec_status(taskname, LAST_EXE_ORDER_KEY)
    last_exec_order = isnothing(last_exec_order) ? 0 : last_exec_order
    exec_order = get_exec_order(taskname)
    exec_order = isnothing(exec_order) ? 1 : exec_order
    exec_order = max(exec_order, last_exec_order) + 1
    last_exec_order = exec_order - 1
    set_exec_order(taskname, exec_order)
    set_exec_status(taskname, false; last_order = last_exec_order)

    println("new exec order: $exec_order")

    println()
    println("------------------ PUSHING MASTER -----------------")
    println()

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)

    # writing
    write_origin_config(ORIGIN_CONFIG, path; create = true)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    !deb && git_add_all()
    !deb && git_commit(commit_msg)
    !deb && git_push(force = true, print = true)

    println()
    println("------------------ READING LOGS -----------------")
    println()
    follow_exec(exec_order, taskroot, init_margin = 0)

end