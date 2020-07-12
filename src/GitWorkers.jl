module GitWorkers

# import TOML
import Dates: now
import JSON

# Globals
include("Globals/Globals.jl")

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

#TaskManager
include("TaskManager/TaskManager.jl")

# Master
include("Master/Master.jl")


# Log
include("LogFiles/LogFiles.jl")


end # module
