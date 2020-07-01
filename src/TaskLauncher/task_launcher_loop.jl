function task_launcher_loop()

    # ------------------- CREATE LOCALS -------------------
    # Check if there exist any origin without a local file
    create_localtasks()

    # ------------------- GET WAITING TASKS -------------------
    waiting_tasks = get_waiting_tasks()
end