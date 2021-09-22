
_TASK_FILE_REGEX = Regex("^(?<taskid>[a-zA-Z0-9]+)\\.task\\.(?<ftype>[a-zA-Z0-9]+)\$")

_task_file(taskid, ftype) = _gitwr_stagedir(string(taskid, ".task", ftype))
_task_file(ftype) = _gitwr_stagedir(string(taskid, ".task", ftype))

_is_task_file(fn) = !isnothing(match(_TASK_FILE_REGEX, fn))

function _find_tasks_files(ftype="expr")
    hint = string(".task.", ftype)
    filterdown(_gitwr_globaldir(); keepout = _keepout_git, onerr = rethrow) do path
        endswith(path, hint)
    end
end

function _task_file_info(fn::String)
    m = match(_TASK_FILE_REGEX, fn)
    isnothing(m) && return (;taskid="", ftype="")
    return (;taskid = m[:taskid], ftype = m[:ftype]) 
end
