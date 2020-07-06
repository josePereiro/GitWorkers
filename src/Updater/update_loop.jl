
# function update_loop(maxwt = 10)

#     while true

#         # Wait a random time 
#         sleep(maxwt * rand())

#         # ------------------- FORCE "PULL" -------------------
#         # This force the local repo to be equal to the origin
#         # This is a fundamental design desition. This way the 
#         # worker code is more robust        
#         !git_force_pull() && continue

#         # ------------------- UPDATE REPO LOCALS -------------------
#         # The local directories of the repo will be overwritten by
#         # its peers in the copy
#         # This implements downstream -> upstream comunication 
#         update_tasklocals()
        
#         # TODO: introduce checks before pushing
#         # ------------------- PUSH ORIGINS -------------------
#         git_add_all() && 
#         git_commit(get_worker_name() * " update") &&
#         git_push()
        
#         # ------------------- UPDATE LOCAL ORIGINS -------------------
#         # The origin directories of the copy will be overwritten by
#         # its peers in the repo
#         # This implements upstream -> downstream comunication 
#         update_taskorigins()
        

#     end

# end