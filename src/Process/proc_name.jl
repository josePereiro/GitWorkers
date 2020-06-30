UPDATER_PROC_NAME = :updater
LIFESAVER_PROC_NAME = :lifesaver
TASK_LAUNCHER_PROC_NAME = :tasklauncher

PROC_NAME = nothing
set_procname(name) = global PROC_NAME = name

ami_updater() = PROC_NAME == UPDATER_PROC_NAME
ami_lifesaver() = PROC_NAME == LIFESAVER_PROC_NAME
ami_tasklauncher() = PROC_NAME == TASK_LAUNCHER_PROC_NAME

