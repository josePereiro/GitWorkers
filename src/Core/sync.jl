## ---------------------------------------------------------------
function _try_sync(fun::Function; 
        msg = "Sync at $(now())", 
        startup = String[], # TODO: connect with config 
        ios = [stdout], 
        force_clonning = false,
        pull = true, 
        push = true,

        success_token = _gen_id(),
        error_token = _gen_id(),
        buff_file = _gitwr_tempfile(),

        att = 5,
    )
        
    url = _get_url()
    urldir = _gitwr_urldir()
    globaldir = _gitwr_globaldir()
    
    urldir_git = _gitwr_urldir(".git")
    urldir_gitignore = _gitwr_urldir(".gitignore")
    force_clonning && rm(urldir_git; force = true, recursive = true)
    recovery_dir = _gitwr_tempdir(_gen_id())
    recovery_git_dir = joinpath(recovery_dir, ".git")
    
    
    
    out = ""
    for _ in 1:att

        # TEST
		println("\n\n------------------------------")

        # down hard
        if pull || force_clonning
            # _, out
            # pull or clone
            # contains(out, error_token) && continue
            
        end

        # custom function
        fun()
        
        # up
        if push
            _, out = _run_bash([ 

                # init
                startup;

                # utils
                _error_cmd_str;
                _success_cmd_str;
                _is_root_cmd_str;

                # go to root
                """mkdir -p "\${sh_repodir}" || _error """;
                """cd "\${sh_repodir}" || _error """;

                # add commit push
                """echo""";
                """echo soft pushing""";
                """_is_root || _error "unexpected repo root" """;
                """[ -f "\${"\${sh_gitignore}"}" ] || _error ".gitignore missing" """;
                """git -C "\${sh_repodir}" add "$(globaldir)" "\${"\${sh_gitignore}"}" || _error "adding global failed" """;
                """git -C "\${sh_repodir}" status || _error """;
                """git -C "\${sh_repodir}" diff-index --quiet HEAD && _success """;
                """git -C "\${sh_repodir}" commit -am "$msg" || _error "commit -am 'msg' failed" """;
                """git -C "\${sh_repodir}" push || _error "git push failed" """;
                """_success"""
            ]; run_fun = _run, ios, buff_file)

            contains(out, success_token) && return true
            contains(out, error_token) && continue
        end
    end 
    return false
end

## ---------------------------------------------------------------
# core sync rutine
function _gwsync(;
        msg = "Client push",
        startup = String[], 
        ios = [stdout], 
        force_clonning = false,
        buff_file = _gitwr_tempfile(), 
        att = 5
    )

    globaldir = _gitwr_globaldir()

    # SYNCHRONIZATION FUN
    function _on_sync()
                
        # every round maintenance
        _force_gitignore()
        _delall()

        # copy stage to globaldir
        stagedir = _gitwr_stagedir()
        for (_root, _, _files) in walkdir(stagedir)
            for name in _files
                stagefile = joinpath(_root, name)
                _on_mtime_event(stagefile; dofirst = true) do
                    globalfile = replace(stagefile, stagedir => globaldir)
                    _cp(stagefile, globalfile)
                end
            end
        end

    end

    _try_sync(_on_sync; 
        buff_file,
        msg, startup, ios, 
        force_clonning, att
    )
end