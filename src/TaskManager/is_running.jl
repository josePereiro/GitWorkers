function is_running(taskfile)
    # checks
    !is_task(taskfile) && error("Not a valid taskfile")

    return haskey(running_tasks, taskfile)
end