const _GW_GITLINK_PROC_OS_UPFREC = 3.0
const _GW_GITLINK_PROC_PTAG = "GITLINK"

## ---------------------------------------------------------------
function _create_gitlink_proc_script(gw::GitWorker, scrfile)
    
    tfile = joinpath(@__DIR__, "gitlink_script_template.jl")
    src = read(tfile, String)

    sroot = sys_root(gw)
    src = replace(src, "__SYS_ROOT__" => sroot)
    url = remote_url(gw)
    src = replace(src, "__REMOTE_URL__" => url)
    src = replace(src, "__GITLINK_PTAG__" => _GW_GITLINK_PROC_PTAG)
    _mkdir(scrfile)
    write(scrfile, src)

    return scrfile
end

## ---------------------------------------------------------------
# OS
function run_gitlink_proc_os(gw::GitWorker)

    while true
        # PROC REGISTRY
        _reg_proc(gw, _GW_GITLINK_PROC_PTAG)

        sleep(_GW_GITLINK_PROC_OS_UPFREC)
    end

end

## ---------------------------------------------------------------
# SPAWN GITLINK PROC
function _spawn_gitlink_proc(gw::GitWorker)

    _is_running(gw, _GW_GITLINK_PROC_PTAG) && return

    scrfile = tempname()
    _create_gitlink_proc_script(gw, scrfile)
    
    projdir = pkgdir(GitWorkers)
    jlcmd = "julia --startup-file=no --project=$(projdir) $(scrfile)"

    pid = _spawn_bash(jlcmd)

    sleep(3.0)
    
    return pid
end
