# ------------------- GITWORKER -------------------
WORKER_FILE_NAME = "gitworker.jl"
WORKER_FILE = find_gitworker_file()
WORKER_DIR = dirname(WORKER_FILE)
WORKER_LOG_DIR = joinpath(WORKER_DIR, "gitworker-logs")
mkpath(WORKER_LOG_DIR)

# ------------------- TASKS -------------------
TASK_FILE_NAME = "task.gitworker.jl"

# ------------------- TASK LAUNCHER -------------------
# stdout
TASK_LAUNCHER_STDOUT_FILE_NAME = "task_launcher.stdout.gitworker.txt"
TASK_LAUNCHER_STDOUT_FILE = joinpath(WORKER_LOG_DIR, TASK_LAUNCHER_STDOUT_FILE_NAME)

TASK_LAUNCHER_LOCAL_STDOUT_FILE_NAME = "task_launcher.stdout.local.gitworker.txt"
TASK_LAUNCHER_LOCAL_STDOUT_FILE = joinpath(WORKER_LOG_DIR, TASK_LAUNCHER_LOCAL_STDOUT_FILE_NAME)

# stderr
TASK_LAUNCHER_STDERR_FILE_NAME = "task_launcher.stderr.gitworker.txt"
TASK_LAUNCHER_STDERR_FILE = joinpath(WORKER_LOG_DIR, TASK_LAUNCHER_STDERR_FILE_NAME)

TASK_LAUNCHER_LOCAL_STDERR_FILE_NAME = "task_launcher.stderr.local.gitworker.txt"
TASK_LAUNCHER_LOCAL_STDERR_FILE = joinpath(WORKER_LOG_DIR, TASK_LAUNCHER_LOCAL_STDERR_FILE_NAME)


# ------------------- UPDATER -------------------
# stdout
UPDATER_STDOUT_FILE_NAME = "updater.stdout.gitworker.txt"
UPDATER_STDOUT_FILE = joinpath(WORKER_LOG_DIR, UPDATER_STDOUT_FILE_NAME)

UPDATER_LOCAL_STDOUT_FILE_NAME = "updater.stdout.local.gitworker.txt"
UPDATER_LOCAL_STDOUT_FILE = joinpath(WORKER_LOG_DIR, UPDATER_LOCAL_STDOUT_FILE_NAME)

# stderr
UPDATER_STDERR_FILE_NAME = "updater.stderr.gitworker.txt"
UPDATER_STDERR_FILE = joinpath(WORKER_LOG_DIR, UPDATER_STDERR_FILE_NAME)

UPDATER_LOCAL_STDERR_FILE_NAME = "updater.stderr.local.gitworker.txt"
UPDATER_LOCAL_STDERR_FILE = joinpath(WORKER_LOG_DIR, UPDATER_LOCAL_STDERR_FILE_NAME)

# ------------------- LIVESAVER -------------------
# stdout
LIVESAVER_STDOUT_FILE_NAME = "livesaver.stdout.gitworker.txt"
LIVESAVER_STDOUT_FILE = joinpath(WORKER_LOG_DIR, LIVESAVER_STDOUT_FILE_NAME)

LIVESAVER_LOCAL_STDOUT_FILE_NAME = "livesaver.stdout.local.gitworker.txt"
LIVESAVER_LOCAL_STDOUT_FILE = joinpath(WORKER_LOG_DIR, LIVESAVER_LOCAL_STDOUT_FILE_NAME)

# stderr
LIVESAVER_STDERR_FILE_NAME = "livesaver.stderr.gitworker.txt"
LIVESAVER_STDERR_FILE = joinpath(WORKER_LOG_DIR, LIVESAVER_STDERR_FILE_NAME)

LIVESAVER_LOCAL_STDERR_FILE_NAME = "livesaver.stderr.local.gitworker.txt"
LIVESAVER_LOCAL_STDERR_FILE = joinpath(WORKER_LOG_DIR, LIVESAVER_LOCAL_STDERR_FILE_NAME)
