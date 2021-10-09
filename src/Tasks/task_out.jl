const _GW_LOG_EXT = ".log"
_is_log(path) = _endswith(path, _GW_LOG_EXT)

# ------------------------------------------------------------------
const _GW_TASK_LOG_EXT = ".task.out"
_task_outname(taskid) = string(taskid, _GW_TASK_LOG_EXT)
_local_task_outfile(taskid) = _local_tasks_outs_dir(_task_outname(taskid))
_repo_task_outfile(taskid) = _repo_tasks_outs_dir(_task_outname(taskid))
_is_taskout(path) = _endswith(path, _GW_TASK_LOG_EXT)
