"""
    Store all processes that the TaskManager tagged to kill. 
"""
PROCS_TO_KILL = Set{Base.Process}()

"""
    Store of all child processes
"""
ALL_PROCS = Set{Base.Process}()
