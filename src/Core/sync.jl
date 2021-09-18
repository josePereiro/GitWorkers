## ---------------------------------------------------------------
function _try_sync(fun::Function; 
        msg = "Sync at $(now())", 
        att = 5,
        startup = String[], # TODO: connect with config 
        ios = [stdout], 
        force_clonning = false, 
        pull = true, 
        push = true
    )
        
    # from
    url = _get_url()
    urldir = _gitwr_urldir()
    
    # from
    success_token = _gen_id()
    fatal_token = _gen_id()
    buff_file = _gitwr_tempfile()
    urldir_git = _gitwr_urldir(".git")
    force_clonning && rm(urldir_git; force = true, recursive = true)
    recovery_dir = _gitwr_tempdir(_gen_id())
    recovery_git_dir = joinpath(recovery_dir, ".git")
    
    _success_cmd_str = """_success () { echo "success token: $(success_token)"; rm -frd "$(recovery_dir)"; exit; }"""
    _fatal_cmd_str = """_fatal () { echo "fatal token: $(fatal_token)"; rm -frd "$(recovery_dir)"; rm -frd "$(urldir_git)"; exit; }"""
    _check_root_str = join([
        """_is_root () {""", 
            """local reporoot="\$(git -C "$(urldir)" rev-parse --show-toplevel)" """, 
            """if [ -d "\${reporoot}" ] && [ "\${reporoot}" != "$(urldir)" ]; then return 1; fi""",
            """return 0""",
        """}""", 
    ], "\n")
    
    out = ""
    # for _ in 1:att
    for _ in 1:2

        # TEST
		println("\n\n------------------------------")

        # down hard
        if pull || force_clonning
            _, out = _run_bash([
                # init
                startup;

                # utils
                _fatal_cmd_str;
                _success_cmd_str;
                _check_root_str;

                # go to root
                """mkdir -p "$(urldir)" || _fatal """;
                """cd "$(urldir)" || _fatal """;
                
                # pull or clonne if necesary
                """if [ -d .git ]; then""";
                    """echo""";
                    """echo pulling hard""";
                    """_is_root || _fatal """;
                    """git -C "$(urldir)" fetch || _fatal """;
                    """git -C "$(urldir)" reset --hard FETCH_HEAD || _fatal """;
                """else""";
                    """echo""";
                    """echo checking repo integrity""";
                    """[ -d .git ] || mkdir -p  "$(recovery_dir)" || _fatal """;
                    """[ -d .git ] || git -C "$(urldir)" clone --depth=1 "$(url)" "$(recovery_dir)" || _fatal """;
                    """[ -d .git ] || mv -f "$(recovery_git_dir)" "$(urldir)" || _fatal """;
                """fi""";
                """rm -frd "$(recovery_dir)" """;

                # success
                """_success"""
            ]; run_fun = _run, ios, buff_file)
            contains(out, fatal_token) && continue
        end

        # custom function
        fun()
        
        # up
        if push
            _, out = _run_bash([ 

                # init
                startup;

                # utils
                _fatal_cmd_str;
                _success_cmd_str;
                _check_root_str;

                # go to root
                """mkdir -p "$(urldir)" || _fatal """;
                """cd "$(urldir)" || _fatal """;

                # add commit push
                """echo""";
                """echo soft pushing""";
                """_is_root || _fatal """;
                """git -C "$(urldir)" add -A || _fatal """;
                """git -C "$(urldir)" diff-index --quiet HEAD && _success """;
                """git -C "$(urldir)" commit -am "$msg" || _fatal """;
                """git -C "$(urldir)" push || _fatal """;
                """_success"""
            ]; run_fun = _run, ios, buff_file)

            contains(out, success_token) && return true
            contains(out, fatal_token) && continue
        end
    end 
    return false
end