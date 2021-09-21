_GITWR_TASK_EXT = ".gitworker.task"

_gitwr_task_file(taskid) = _gitwr_stagedir(string(taskid, _GITWR_TASK_EXT))

_is_task_file(fn) = endswith(fn, _GITWR_TASK_EXT)

_find_tasks() = filterdown(_is_task_file, _gitwr_globaldir(); keepout = _keepout_git, onerr = rethrow)

_extract_task_id(fn) = replace(basename(fn), _GITWR_TASK_EXT => "")