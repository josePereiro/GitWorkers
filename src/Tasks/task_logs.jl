const _GITWR_TASK_LOG_EXT = ".task.log"
_task_logname(taskid) = string(taskid, _GITWR_TASK_LOG_EXT)
_local_tasklog(taskid) = _local_logsdir(_task_logname(taskid))
_repo_tasklog(taskid) = _repo_logsdir(_task_logname(taskid))
_is_tasklog(path) = endswith(path, _GITWR_TASK_LOG_EXT)