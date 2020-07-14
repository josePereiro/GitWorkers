
function master_update(path = pwd(); 
        before_pull = (worker) -> nothing,
        before_push = (worker) -> nothing,
        commit_msg = get_workername(path) * " master update",
        verbose = true,
        deb = false)

    worker = find_ownerworker(path)

    # ------------------- MAKE CUSTOM TASK -------------------
    before_pull(worker)

    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME, worker)

    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker code is more robust        
    !deb && git_pull(force = true, print = verbose)

    # ------------------- MAKE CUSTOM TASK -------------------
    before_push(worker)

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME, worker)

    # writing
    write_config(worker; create = true)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    !deb && git_add_all(print = verbose)
    !deb && git_commit(commit_msg; print = verbose)
    !deb && git_push(force = true, print = verbose)
    
end