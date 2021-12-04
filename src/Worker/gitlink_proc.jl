const _GW_GITLINK_PROC_OS_UPFREC = 10.0
const _GW_GITLINK_PROC_PTAG = "GITLINK"

## ---------------------------------------------------------------
function _create_gitlink_proc_script(gw::GitWorker, scrfile; 
        clear_script::Bool = true, verbose::Bool = false
    )
    
    tfile = joinpath(@__DIR__, "gitlink_script_template.jl")
    src = read(tfile, String)
    src = replace(src, "__CLEAR_SCRIPT__" => string(clear_script))

    sroot = sys_root(gw)
    src = replace(src, "__SYSTEM_ROOT__" => "\"$(sroot)\"")
    url = remote_url(gw)
    src = replace(src, "__REMOTE_URL__" => "\"$(url)\"")
    src = replace(src, "__GITLINK_PTAG__" => "\"$(_GW_GITLINK_PROC_PTAG)\"")
    src = replace(src, "__GL_VERBOSE__" => string(verbose))
    _mkdir(scrfile)
    write(scrfile, src)

    println(src)

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
function _spawn_gitlink_proc(gw::GitWorker; deb = false)

    _is_running(gw, _GW_GITLINK_PROC_PTAG) && return

    scrfile = tempname()
    _create_gitlink_proc_script(gw, scrfile; clear_script = true, verbose = deb)
    
    projdir = pkgdir(GitWorkers)
    
    jlcmd = "julia --startup-file=no --project=$(projdir) $(scrfile)"

    # pid = _spawn_bash(jlcmd)

    # Test
    pid = -1
    _run_bash(jlcmd)

    return pid
end
