# ------------------------------------------------------------------
const _GW_TASK_OUT_FILE_EXT = ".task.out"
_task_outname(taskid) = string(taskid, _GW_TASK_OUT_FILE_EXT)
_local_task_out_file(taskid) = _local_tasks_outs_dir(_task_outname(taskid))
_repo_task_out_file(taskid) = _repo_tasks_outs_dir(_task_outname(taskid))
_is_taskout(path) = _endswith(path, _GW_TASK_OUT_FILE_EXT)
