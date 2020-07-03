module GitWorkers

import TOML

# Globals deps

# Globals


# Utils
include("Utils/Utils.jl")

#Git
include("Git/Git.jl")

# Workers
include("Workers/Workers.jl")

# Tasks
include("Tasks/Task.jl")

# Updater
include("Updater/Updater.jl")

#TaskManager
include("TaskManager/TaskManager.jl")

# Log
include("Log/log.jl")


end # module
