# """
#     Returns the satatus file of the owner task of the 
#     giving taskfile. `nothing` if any problem.
# """
# function find_taskstatus_files(taskfile)
#     !ispath(taskfile) && return nothing
#     taskfile = find_owner_task(taskfile)
#     isnothing(taskfile) && return nothing
#     taskdir = taskfile |> dirname
#     files = joinpath.(taskdir, readdir(taskdir))
#     statusfiles = filter(files) do file 
#         endswith(file, TASKS_STATUS_FILE_SUFFIX)
#     end
#     return isempty(statusfiles) ? nothing : statusfiles
# end

# """
#     Returns the tasks that are ready to be runned
# """
# function find_tasks_by_status(status)
#     task_files = find_taskfiles()
#     task_locals = filter(is_tasklocal, task_files);
#     return filter(task_locals) do task
#         read_taskstatus(task) == status
#     end
# end

# """
#     return get_taskstatus(taskfile) == WAITING_STATUS
# """
# is_task_waiting(taskfile) = read_taskstatus(taskfile) == WAITING_STATUS


# """
#     Get the path of the status file for the 
#     owner task of the given taskfile
# """
# function get_taskstatus_file(status, taskfile)
#     owner_task = find_owner_task(taskfile)
#     isnothing(owner_task) && error("Not a task file")
#     return joinpath(owner_task |> dirname, status * TASKS_STATUS_FILE_SUFFIX)
# end

# """
#     Returns the status of a gven task. It look for the 
#     file ended in TASKS_STATUS_FILE_SUFFIX in the taskfile 
#     owner folder, and read the status from the name.
#     If the file is missing the method will return whatever 
#     is passed in `onerr`.
#     If many status files are present, the first one
#     in alphabetical order will be read
# """
# function read_taskstatus(taskfile; 
#         onerr = WAITING_STATUS)

#     status_files = find_taskstatus_files(taskfile);
#     isempty(status_files) && return onerr
#     return replace(status_files |> sort! |> first |> basename,  
#         TASKS_STATUS_FILE_SUFFIX => "")
# end

# function write_taskstatus(status, taskfile)
#     touch(get_taskstatus_file(status, taskfile))
# end