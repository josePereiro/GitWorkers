
function push_master(path = pwd(), 
        msg = get_workername(path) * " master update")
    
    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME)

    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker code is more robust        
    git_pull(force = true, print = true)

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)

    # writing
    write_config(ORIGIN_CONFIG, path; create = true)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    git_add_all()
    git_commit(msg)
    git_push(force = true, print = true)
    
end