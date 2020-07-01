module GitWorkers

using Distributed

# Utils
include("Utils/look_up.jl")
include("Utils/look_down.jl")
include("Utils/gwprint.jl")
include("Utils/is_subpath.jl")


# DirTree
include("DirTree/find_repo_root_dir.jl")
include("DirTree/find_gitworker_file.jl")
include("DirTree/dirs_and_files.jl")

# Process
include("Process/config.jl")
include("Process/update_config.jl")
include("Process/check_init.jl")
include("Process/proc_name.jl")
include("Process/status.jl")

# Tasks
include("Tasks/const.jl")
include("Tasks/taskorigins.jl")
include("Tasks/start_task_launcher.jl")
include("Tasks/find_taskfiles.jl")
include("Tasks/taskpaths.jl")
include("Tasks/tasklocals.jl")
include("Tasks/find_owner_task.jl")

# Updater
include("Updater/get_tracked.jl")
include("Updater/get_local_changes.jl")
include("Updater/update_loop.jl")


end # module
