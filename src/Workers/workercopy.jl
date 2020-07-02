# # owner = find_ownerworker(path, unsafe = true)
#     # isnothing(owner) && return false

# is_workercopy_dir(workerdir) = endswith(workerdir, COPY_DIR_SUFFIX)
# is_copypath(path) = is_workercopy_dir(find_ownerworker(path))
# build_workercopy_dir(workerdir) = workerdir * COPY_DIR_SUFFIX

# """
#     Get the abspath of the worker copy dir.
#     If the given path already belong to a 
#     worker copy, this owner will be returned.
#     If the given path doesn't belong to a 
#     worker throw an error.
#     This method do not check if the copy path
#     exist
# """
# function get_workercopy_dir(path)
#     owner = find_ownerworker(path)
#     ownerdir = owner |> dirname
#     return is_workercopy_dir(ownerdir) ? ownerdir : 
#         build_workercopy_dir(ownerdir)
# end

# """
#     Returns the mirror of the the given path in the
#     owner worker copy dir.
#     If path is already in the copy folder, return path.
#     If path doesn't exist of have no owner throw an error
# """
# function get_copypath(path)
#     path = path |> abspath
#     is_copypath(path) && return path
#     workercopy_dir = get_workercopy_dir(path)
#     worker_dir = find_ownerworker(path) |> dirname
#     return replace(path, worker_dir => workercopy_dir)
# end