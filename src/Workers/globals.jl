# ------------------- GITWORKER -------------------
WORKER_FILE_NAME = "gitworker.jl"
# by default, the first worker will be loaded
WORKER_DIR = let
    worker_files = find_gitworkerfiles()
    isempty(worker_files) && error("Not in a 'GitWorker' repo, "*
        "any $WORKER_FILE_NAME found")
    worker_files |> sort! |> first |> dirname
end
WORKER_NAME = WORKER_DIR |> dirname

# ------------------- TASKS -------------------
TASK_FILE_NAME = "task.gitworker.jl"
STDOUT_FILE_SUFFIX = ".stdout.gitworker.txt"
STDERR_FILE_SUFFIX = ".stdout.gitworker.txt"