# # ---------------------------------------------------------------
# # transient data un-synchronized with upstream
# const _GITWR_TEMPDIR_NAME = ".temp"

# function _gitwr_tempdir() 
#     dir = _urldir(_GITWR_TEMPDIR_NAME)
#     !isdir(dir) && mkpath(dir)
#     return dir
# end
# _gitwr_tempdir(n, ns...) = joinpath(_gitwr_tempdir(), string(n), string.(ns)...)

# function _gitwr_tempfile()
#     while true
#         file = _gitwr_tempdir(_gen_id())
#         !isfile(file) && return file
#     end
# end

# _del_gitwr_tempfiles() = rm(_gitwr_tempdir(); recursive = true, force = true)

# function _ls_gitwr_tempdir()
#     dir = _gitwr_tempdir()
#     println.(isdir(dir) ? readdir(dir) : String[])
#     return nothing
# end