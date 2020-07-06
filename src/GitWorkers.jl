module GitWorkers

import TOML

# Utils
include("Utils/Utils.jl")

# ControlFiles
include("ControlFiles/ControlFiles.jl")

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

# Master
include("Master/Master.jl")


# Log
include("Log/log.jl")


end # module
