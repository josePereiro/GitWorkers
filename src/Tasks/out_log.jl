const _GW_TASK_OUT_LOG_FILE_NAME = "out.log"
_taskout_file(taskdir::String) = joinpath(taskdir, _GW_TASK_OUT_LOG_FILE_NAME)
_taskout_file(gwt::GWTask) =  _taskout_file(task_dir(gwt))