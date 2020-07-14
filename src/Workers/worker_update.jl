function worker_update(path = pwd(); 
    before_pull = (worker) -> nothing,
    before_push = (worker) -> nothing,
    after_push = (worker) -> nothing,
    commit_msg = get_workername(path) * " worker update",
    verbose = true,
    deb = false)

    worker = find_ownerworker(path)

    verbose && println(
    "\n------------------- SYNC REPO -------------------\n\n")

    # Custom computation
    before_pull(worker)

    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker is more robust    
    verbose && println("Force pull from origin")    
    !deb && git_pull(force = true; print = verbose)

    # ------------------- UPDATE ORIGIN_CONFIG -------------------
    # Now ORIGIN_CONFIG is up to date with the data from origin
    verbose && println("Updating ORIGIN_CONFIG from $(ORIGIN_CONFIG_FILE_NAME)")
    read_config(worker)
    verbose && println()

    # ------------------- UPDATE REPO TASKS LOCALS -------------------
    # The local directories of the repo will be overwritten by
    # its peers in the copy
    # This implements downstream -> upstream comunication 
    sync_taskdirs(FROM_COPY, LOCAL_FOLDER_NAME, worker)

    # Custom computation
    before_push(worker)

    # ------------------- UPDATE LOCAL STATUS FILE -------------------
    # the updated local status is written in the file
    # The next repo sync will reflect that
    verbose && println()
    verbose && println("Updating $(LOCAL_STATUS_FILE_NAME) from LOCAL_STATUS")
    write_status(worker; create = true)
    verbose && println()

    # ------------------- UPDATE LOCAL ORIGINS -------------------
    # The origin directories of the copy will be overwritten by
    # its peers in the repo
    # This implements upstream -> downstream comunication 
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME, worker)

    # Custom computation
    after_push(worker)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    push_token = get_config(PUSH_TOKEN_KEY, VALUE_KEY)
    verbose && isnothing(push_token) && println("$PUSH_TOKEN_KEY: missing")
    verbose && !isnothing(push_token) && pretty_print(Dict(PUSH_TOKEN_KEY => get_config(PUSH_TOKEN_KEY)))
    verbose && println()
    flush(stdout)
    if !isnothing(push_token) && push_token
        verbose && println("Adding to local repo")
        !deb && git_add_all(print = verbose)
        msg = get_workername(worker) * " update"
        verbose && println("\nCommiting, -m '$msg'")
        !deb && git_commit(msg; print = verbose)
        verbose && println("\nPushing to origin")
        !deb && git_push(print = verbose)
    end

end