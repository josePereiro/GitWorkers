
# ------------------- DIRS -------------------
!isdir("../test") && error("You must run `runtest.jl` from test dir")
REPOROOT = "TestRepo" |> abspath
REPO = joinpath(REPOROOT, ".git")
mkpath(REPO)

WORKERROOT = joinpath(REPOROOT, "Worker")
TASKROOT = joinpath(WORKERROOT, "Task")
NOT_WORKERROOT = joinpath(REPOROOT, "NotAWorker")
NOT_TASKROOT = joinpath(WORKERROOT, "NotATask")

# ------------------- TEST FILES -------------------
GITWORKER = joinpath(WORKERROOT, GW.WORKER_FILE_NAME)
NOT_GITWORKER = joinpath(NOT_WORKERROOT, "not_$(GW.WORKER_FILE_NAME)")

TASK = joinpath(TASKROOT, GW.ORIGIN_FOLDER_NAME, GW.TASK_FILE_NAME)
NOT_TASKS = joinpath.(NOT_TASKROOT, [
    GW.TASK_FILE_NAME, 
    joinpath("not_$(GW.ORIGIN_FOLDER_NAME)", GW.TASK_FILE_NAME),
    joinpath(GW.LOCAL_FOLDER_NAME, GW.TASK_FILE_NAME),
    joinpath(GW.ORIGIN_FOLDER_NAME, "not_$(GW.TASK_FILE_NAME)")
])

TEST_FILE_NAME = "test_file.jl"
REPOLEVEL_TESTFILES = [joinpath(REPOROOT, TEST_FILE_NAME), 
joinpath(REPOROOT, fill("subfolder", 3)..., TEST_FILE_NAME)]

WORKERLEVEL_TESTFILES = [joinpath(WORKERROOT, TEST_FILE_NAME), 
    joinpath(WORKERROOT, fill("subfolder", 3)..., TEST_FILE_NAME)]

TASKLEVEL_TESTFILES = map([TASKROOT, joinpath(TASKROOT, GW.ORIGIN_FOLDER_NAME),
        joinpath(TASKROOT, GW.LOCAL_FOLDER_NAME), joinpath(TASKROOT, "subfolder"), 
        joinpath(TASKROOT, fill("subfolder", 2)...)]) do dir
    joinpath(dir, TEST_FILE_NAME)
end

NOT_A_PATH = joinpath(REPOROOT, "Worker/not_a_path.jl") # Do not create!!
@assert NOT_A_PATH |> !ispath


# Build TestRepo
FILES = [GITWORKER; NOT_GITWORKER; TASK; NOT_TASKS; 
    REPOLEVEL_TESTFILES; WORKERLEVEL_TESTFILES; TASKLEVEL_TESTFILES]
for file in FILES
    mkpath(file |> dirname)
    touch(file)
end