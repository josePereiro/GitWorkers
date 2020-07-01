"""
    Configure GiWorker package to work with a given 
    worker.
"""
function init(path)
    workerfile = find_ownerworker(path)
    global WORKER_DIR = workerfile |> dirname
end