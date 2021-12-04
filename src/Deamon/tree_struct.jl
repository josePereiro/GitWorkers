# sys def root
const _GW_SYSTEM_DFLT_ROOT = homedir()

# depot dir
const _GW_DEPOT_NAME = ".gitworkers"
_depot_dir(sys_root::String) = joinpath(sys_root, _GW_DEPOT_NAME)
depot_dir(d::GWDeamon) = _depot_dir(sys_root(d))

# deamon dir
const _GW_DEAMON_FOLDER_NAME = "gwdeamon"
_deamon_dir(sys_root::String) = joinpath(_depot_dir(sys_root), _GW_DEAMON_FOLDER_NAME)
deamon_dir(d::GWDeamon) = _deamon_dir(sys_root(d))