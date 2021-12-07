task_dir(gw::GitWorker, tid::String) = joinpath(tasks_dir(gw), tid)

logs_dir(gwt::GWTask) = worker_root(gwt)
procs_dir(gwt::GWTask) = procs_dir(gitworker(gwt))