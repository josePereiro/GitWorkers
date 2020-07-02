# TODO: Rigth now the manager will run only one task 
# TODO: To fix that, implement untracked temporal logs for the running tasks
# and updated when more convinient at the time
# cmd = Cmd(`$julia $run_task_file`, env = ENV)
#     run(pipeline(cmd, stdout = open(log_file, "a"), 
#         stderr = open(error_file, "a")), wait = true);
include("globals.jl")
include("launch_tasks.jl")
include("get_exe_order.jl")
include("is_executable_task.jl")
include("running_tasks.jl")