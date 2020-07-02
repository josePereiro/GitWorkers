# """
#     This function checks for the tracked in the task origin folders and create the 
#     local copies if required
# """
# function create_localtasks()

#     tracked_files = get_tracked()

#     # ALL origin task files must have a local copy. 
#     task_origins = filter(is_taskorigin, tracked_files);
#     for origin_ in task_origins
#         !ispath(origin_) && continue
#         isdir(origin_) && continue # TODO: think implementing tracked dirs

#         local_ = get_tasklocal(origin_)

#         update_ = !ispath(local_)
#         if update_
            
#             # make dir
#             local_dir = local_ |> dirname
#             if !isdir(local_dir)
#                 mkpath(local_dir)
#                 log(local_dir |> relpath, " created!!!")
#             end
            
#             local_ = cp(origin_, local_)
#             log(local_ |> relpath, " touched!!!")
#         end
#     end

# end