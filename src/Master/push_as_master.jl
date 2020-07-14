
function push_as_master(path = pwd(); 
        commit_msg = get_workername(path) * " master update",
        verbose = true,
        deb = false)

    worker = find_ownerworker(path)

    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME)

    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker code is more robust        
    !deb && git_pull(force = true, print = verbose)

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)

    # writing
    write_config(worker; create = true)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    !deb && git_add_all(print = verbose)
    !deb && git_commit(commit_msg; print = verbose)
    !deb && git_push(force = true, print = verbose)
    
end