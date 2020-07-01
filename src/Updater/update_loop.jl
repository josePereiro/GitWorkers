
function update_loop()

    while true

        # ------------------- FORCE "PULL" -------------------
        # This force the local repo to be equal to the origin
        # This is a fundamental design desition. This way the 
        # worker code is more robust
        try
            run(`git fetch && git reset --hard FETCH_HEAD`)
        catch err
            # TODO: log the error
            sleep(5) # TODO: organize waiting times
            continue
        end

        # ------------------- COLLECT ALL LOCAL CHANGES -------------------
        # The repo files all only mutables after the forced "pull". That's 
        # why the tasks are runned in a local directory. Now we collect all 
        # the possibles changes in tracked files to add then and commit before
        # trying to push
        to_update = get_local_changes()

        
    end

end