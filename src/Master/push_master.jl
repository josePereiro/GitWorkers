
function push_master()
    
    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    sync_taskdirs(FROM_REPO, ORIGIN_FOLDER_NAME)

    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker code is more robust        
    !git_pull(force = true) && return

    # ------------------- COPY BACK -------------------
    sync_taskdirs(FROM_COPY, ORIGIN_FOLDER_NAME)

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    git_add_all() && 
    git_commit(get_workername() * " update") &&
    git_push(force = true)
    
end