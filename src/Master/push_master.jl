
function push_master()
    
    # ------------------- SAVE REPO ORIGIND IN COPY -------------------
    update_taskorigins()

    # ------------------- FORCE "PULL" -------------------
    # This force the local repo to be equal to the origin
    # This is a fundamental design desition. This way the 
    # worker code is more robust        
    !git_force_pull() && return

    # ------------------- SYNC ORIGINS -------------------
    copyback_taskorigins()

    # TODO: introduce checks before pushing
    # ------------------- PUSH ORIGINS -------------------
    git_add_all() && 
    git_commit(get_worker_name() * " update") &&
    git_push(force = true)
    
end