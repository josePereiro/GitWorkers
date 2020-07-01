# TODO: Rigth now the manager will run only one task 
# TODO: To fix that, implement untracked temporal logs for the running tasks
# and updated when more convinient at the time
# cmd = Cmd(`$julia $run_task_file`, env = ENV)
#     run(pipeline(cmd, stdout = open(log_file, "a"), 
#         stderr = open(error_file, "a")), wait = true);
    
function task_launcher_loop()

        # ------------------- CREATE LOCALS -------------------
        # Check if there exist any origin without a local file
        create_localtasks()

        # ------------------- GET WAITING TASKS -------------------
        waiting_tasks = 
end