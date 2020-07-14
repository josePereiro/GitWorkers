
function master_update(path = pwd(); 
        before_pull = (worker) -> nothing,
        before_push = (worker) -> nothing,
        commit_msg = get_workername(path) * " master update",
        verbose = true,
        deb = false)

    worker = find_ownerworker(path)

    # Custom computation
    before_pull(worker)

    verbose && print_title("SAVE CACHE")
    # ------------------- SAVE REPO ORIGINS IN COPY -------------------
    verbose && println("Sync $(ORIGIN_FOLDER_NAME) dirs from repo")
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME, worker)
    
    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker code is more robust        
    verbose && print_title("SYNC REPO FROM ORIGIN")
    !deb && git_pull(force = true, print = verbose)
    read_config(worker)
    read_status(worker)
    
    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME, worker)

    # ------------------- MAKE CUSTOM TASK -------------------
    before_push(worker)

    # ------------------- PUSH ORIGINS -------------------
    verbose && print_title("SYNC ORIGIN FROM REPO")
    write_config(worker; create = true)
    !deb && git_add_all(print = verbose)
    !deb && git_commit(commit_msg; print = verbose)
    !deb && git_push(force = true, print = verbose)
    
end