const _GW_LOG_EXT = ".log"
_is_log(path) = endswith(path, _GW_LOG_EXT)

# ------------------------------------------------------------------
const _GW_TASK_LOG_EXT = string(".task", _GW_LOG_EXT)
_task_logname(taskid) = string(taskid, _GW_TASK_LOG_EXT)
_local_tasklog(taskid) = _local_logsdir(_task_logname(taskid))
_repo_tasklog(taskid) = _repo_logsdir(_task_logname(taskid))
_is_tasklog(path) = endswith(path, _GW_TASK_LOG_EXT)
