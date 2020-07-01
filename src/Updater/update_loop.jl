
function update_loop(maxwt = 10)

    while true

        flush(stdout) # Test

        # Wait a random time 
        sleep(maxwt * rand())

        # ------------------- FORCE "PULL" -------------------
        # This force the local repo to be equal to the origin
        # This is a fundamental design desition. This way the 
        # worker code is more robust
        global curr_pull_start_time = time()        
        !force_pull() && continue
        global previous_pull_start_time = curr_pull_start_time

        # Wait a random time 
        sleep(5)

        # ------------------- UPDATE ORIGINS -------------------
        # The origin files all only mutables after the forced "pull". That's 
        # why the tasks are runned in a local directory. Now we collect all 
        # the possibles changes in tracked files to add then and commit before
        # trying to push
        global curr_origin_up_start_time = time()
        update_origins()
        global previous_origin_up_start_time = curr_origin_up_start_time
        global curr_origin_up_end_time = time()
        global previous_origin_up_end_time = curr_origin_up_end_time
        

        # ------------------- PUSH ORIGINS -------------------
        !add_commit_origins() && continue
        push()
    end

end