module GitWorkers

using Distributed

# Utils
include("Utils/look_up.jl")
include("Utils/look_down.jl")

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
include("Tasks/start_task_launcher.jl")
include("Tasks/find_taskfiles.jl")
include("Tasks/is_task.jl")
include("Tasks/find_owner_task.jl")



# Updater
include("Updater/get_git_tracked.jl")

end # module
