"""
    Reset the stateful globals
"""
function reset()
    global ORIGIN_CONFIG = Dict()
    global LOCAL_STATUS = Dict()
    global PROCS_TO_KILL = Set{Base.Process}()
    global ALL_PROCS = Set{Base.Process}()
end