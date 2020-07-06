# """
#     This method check in the exe-config and exec-status files of all 
#     copy tasks for a new execution order and runs the task in a 
#     chield process. The task_dict is updated to track the task state.
#     If the task is already running, the execution order is ignored 
#     till the task is finished or die.
#     The process is repeated in a given frec
# """
# function task_manager_loop(maxtime = 10)

#     while true

#         println("Task Manager Loop")

#         try
#             tasks = find_tasks()
#             copytasks = filter((file) -> file |> get_taskroot |> is_copytaskroot, tasks)
#             for copytask in copytasks
                
                
#                 println("$(relpath(copytask))")
                
                
#                 # ------------------- KILL RUNNING TASK -------------------
#                 # If the kill state is `true` and the task is running, the process
#                 # executing the task will be kill
#                 killable = get_kill_config(copytask)
#                 killable && is_taskrunning(copytask) && kill_taskproc(copytask)
#                 println("killable: ", killable)
                
                
#                 # ------------------- LAUNCHING TASK -------------------
#                 # If the kill state is `true` and the task is running, the process
#                 # executing the task will be kill
#                 executable = get_executable_config(copytask)
#                 executable && !is_taskrunning(copytask) && !killable && run_taskproc(copytask)
#                 println("executable: ", executable)

#                 println("is_running: ", is_taskrunning(copytask))
#                 flush(stdout)

#             end
#         catch err
#             rethrow(err)
#         end

#         sleep(maxtime * rand())
#     end # Loop

# end