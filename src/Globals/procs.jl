"""
    Store all processes that the TaskManager tagged to kill. 
"""
PROCS_TO_KILL = Set{Base.Process}()

"""
    Store of all child processes directly started by the worker
"""
ALL_PROCS = Set{Base.Process}()
