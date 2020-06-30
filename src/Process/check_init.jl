"""
    This are checks for for the beginning
"""
function check_init()

    #= TODO: Check for the GW.CONFIG["JULIA_EXE"] to be callable, maybe make a subprocess 
    to run some test task =#
    julia_exe = Sys.which(CONFIG["JULIA_EXE"])
    isnothing(julia_exe) && error("julia_exe ($julia_exe) not working, "*
        "it could be missing from path or you have not permission to executed!!!")
end

"""
    Check init in many workers
"""
check_init(workers) = foreach(workers) do w 
    remotecall_wait(check_init, w)
end
