"""
    This method check in the exe-config and exec-status files of all 
    copy tasks for a new execution order and runs the task in a 
    chield process. The task_dict is updated to track the task state.
    If the task is already running, the execution order is ignored 
    till the task is finished or die
"""
function launch_tasks()

    tasks = find_tasks()
    copytasks = filter((file) -> file |> get_taskroot |> is_copytaskroot, tasks)
    for copytask in copytasks

        
    end
end