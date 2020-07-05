# TODO: Add tests
"""
    Look down for the task files in the path 
    owner worker.
    Returns an abspaths array or []. 
"""
find_tasks(path = pwd()) = findall_worker(is_task, path)

"""
    The method look up till find an taskfile, if check = true
    throw an error if nothing if found. 
    Returns an abspath or nothing
"""
function find_ownertask(path = pwd(); check = true)
    taskroot = findup_repo(is_taskroot, path)
    check && isnothing(taskroot) && error("Not in a `Task` directoty, " *
        "$(TASK_FILE_NAME) not found!!!")
    isnothing(taskroot) && return nothing
    return joinpath(taskroot, TASK_PATTERN)
end

function find_ownertask_root(path = pwd(); check = true)
    ownertask = find_ownertask(path; check = check)
    return isnothing(ownertask) ? nothing : ownertask |> get_taskroot
end

has_ownertask(path = pwd()) = !isnothing(find_ownertask(path; check = false))

findall_task(fun::Function, path = pwd()) = findall_down(fun, find_ownertask(path));
findall_task(name::AbstractString) = 
    findall_task((path) -> basename(path) == name);

findin_task(fun::Function, path = pwd()) = find_down(fun, find_ownertask(path));
findin_task(name::AbstractString) = 
    findin_task((path) -> basename(path) == name);

"""
    Returns the path to the exec_config_file
    of the path owner task. If path is not a 
    task path throw an error.
"""
function find_task_exec_config_file(path = pwd())
    taskdir = find_ownertask_root(path);
    exec_config_file =  build_task_exec_config_file(taskdir)
    return isfile(exec_config_file) ? exec_config_file : nothing
end

"""
    Returns the path to the exec_status_file
    of the path owner task. If path is not a 
    task path throw an error.
"""
function find_task_exec_status_file(path = pwd())
    taskdir = find_ownertask_root(path);
    exec_status_file = build_task_exec_status_file(taskdir)
    return isfile(exec_status_file) ? exec_status_file : nothing
end