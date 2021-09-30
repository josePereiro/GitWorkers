# # ---------------------------------------------------------------
# # transient data un-synchronized with upstream
# const _GW_TEMPDIR_NAME = ".temp"

# function _gw_tempdir() 
#     dir = _urldir(_GW_TEMPDIR_NAME)
#     !isdir(dir) && mkpath(dir)
#     return dir
# end
# _gw_tempdir(n, ns...) = joinpath(_gw_tempdir(), string(n), string.(ns)...)

# function _gw_tempfile()
#     while true
#         file = _gw_tempdir(_gen_id())
#         !isfile(file) && return file
#     end
# end

# _del_gw_tempfiles() = rm(_gw_tempdir(); recursive = true, force = true)

# function _ls_gw_tempdir()
#     dir = _gw_tempdir()
#     println.(isdir(dir) ? readdir(dir) : String[])
#     return nothing
# end