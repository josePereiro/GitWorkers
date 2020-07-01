module GitWorkers

import JSON

# Globals deps

# Globals


# Utils
include("Utils/Utils.jl")

# # Repo
include("Repo/Repo.jl")

# # # Worker
# include("Worker/find_repo_root_dir.jl")
# include("Worker/find_gitworker_file.jl")
# include("Worker/dirs_and_files.jl")
# include("Worker/meta.jl")

# # Process
# include("Process/config.jl")
# include("Process/update_config.jl")
# include("Process/check_init.jl")
# include("Process/proc_name.jl")
# include("Process/status.jl")

# # Tasks
# include("Tasks/const.jl")
# include("Tasks/taskorigins.jl")
# include("Tasks/start_task_launcher.jl")
# include("Tasks/find_taskfiles.jl")
# include("Tasks/taskpaths.jl")
# include("Tasks/tasklocals.jl")
# include("Tasks/find_owner_task.jl")

# # Updater
# include("Updater/globals.jl")
# include("Updater/get_tracked.jl")
# include("Updater/force_pull.jl")
# include("Updater/push.jl")
# include("Updater/add_file.jl")
# include("Updater/commit.jl")
# include("Updater/add_commit_origins.jl")
# include("Updater/update_origins.jl")
# include("Updater/get_local_changes.jl")
# include("Updater/update_loop.jl")

# # TaskLauncher
# include("TaskLauncher/create_localtasks.jl")
# include("TaskLauncher/task_launcher_loop.jl")
# include("TaskLauncher/taskstatus_file.jl")
# include("TaskLauncher/valid_taskstatus.jl")




# # Log
# include("Log/log.jl")


end # module
