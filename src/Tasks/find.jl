
"""
Look down for the gittask files.
Returns an abspaths array or []. 
"""
find_tasks() = findall_worker(is_task)

"""
    The method look up till find an taskfile, if unsafe = false
    throw an error if nothing if found. 
    Returns an abspath or nothing
"""
function find_ownertask(path = pwd(); unsafe = false)
    !ispath(path) && error("Path $(relpath(path)) not found")
    dir = isdir(path) ? path : dirname(path)
    taskroot = find_up(is_taskroot, dir)
    !unsafe && isnothing(taskroot) && error("Not in a `Task` directoty, " *
        "$(TASK_FILE_NAME) not found!!!")
    return joinpath(taskroot, TASK_PATTERN)
end

function find_ownertask_root(path = pwd(); unsafe = false)
    ownertask = find_ownertask(path; unsafe = unsafe)
    return isnothing(ownertask) ? nothing : ownertask |> get_taskroot
end

has_ownertask(path = pwd()) = !isnothing(find_ownertask(path; unsafe = true))

findall_task(fun::Function, path = pwd()) = findall_down(fun, find_ownertask(path));
findall_task(name::AbstractString) = 
    findall_task((path) -> basename(path) == name);

findin_task(fun::Function, path = pwd()) = find_down(fun, find_ownertask(path));
findin_task(name::AbstractString) = 
    findin_task((path) -> basename(path) == name);
