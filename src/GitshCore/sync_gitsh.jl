## ---------------------------------------------------------------
function _try_sync(fun::Function; 
        msg = "Update at $(now())", 
        repo_dir = _gitsh_urldir(),
        url = _get_url(),
        att = 5,
        startup = String[], # TODO: connect with config 
        ios = [stdout], 
        buff_file = _tempfile(repo_dir), 
        force_clonning = false
    )

    # utils
    success_token = _gen_id()
    fatal_token = _gen_id()
    repo_dir = abspath(repo_dir)
    repo_dir_git = joinpath(repo_dir, ".git")
    force_clonning && rm(repo_dir_git; force = true, recursive = true)
    recovery_dir = _tempfile(repo_dir)
    recovery_git_dir = joinpath(recovery_dir, ".git")
    
    _success_cmd_str = """_success () { echo "success token: $success_token"; rm -frd "$(recovery_dir)"; exit; }"""
    _fatal_cmd_str = """_fatal () { echo "fatal token: $fatal_token"; rm -frd "$(recovery_dir)"; rm -frd "$(repo_dir_git)"; exit; }"""

    for _ in 1:att

        # TEST
		println("\n\n------------------------------")

        # down hard
        @time _, out = Gitsh._run_bash([
            # init
            startup;

            # utils
            _fatal_cmd_str;
            _success_cmd_str;

            # go to root
            """mkdir -p "$(repo_dir)" || _fatal """;
            """cd "$(repo_dir)" || _fatal """;
            
            # clonning if necesary
            """echo""";
            """echo checking repo integrity""";
            """[ -d .git ] || mkdir -p  "$(recovery_dir)" || _fatal """;
            """[ -d .git ] || git clone --depth=1 "$(url)" "$(recovery_dir)" || _fatal """;
            """[ -d .git ] || mv -f "$(recovery_git_dir)" "$(repo_dir)" || _fatal """;
            """rm -frd "$(recovery_dir)" """;

            # pull hard
            """echo""";
            """echo pulling hard""";
            """git fetch || _fatal """;
            """git reset --hard FETCH_HEAD || _fatal """;

            # success
            """_success"""
        ]; run_fun = _run, ios, buff_file)
        contains(out, fatal_token) && continue

        # custom function
        fun()
        
        # up
        @time _, out = Gitsh._run_bash([ 
            # init
            startup;
            # utils
            _fatal_cmd_str;
            _success_cmd_str;

            # add commit push
            """echo""";
            """echo soft pushing""";
            """cd "$repo_dir" || _fatal """;
            """git add -A || _fatal """;
            """git diff-index --quiet HEAD && _success """;
            """git commit -am "$msg" || _fatal """;
            """git push || _fatal """;
            """_success"""
        ]; run_fun = _run, ios, buff_file)

        contains(out, success_token) && return true
        contains(out, fatal_token) && continue
    end 
    return false
end

## ---------------------------------------------------------------
# TODO: connect with config
function _pull_gitsh(; verb = false, force = true)

    # gitsh
    gitsh = _gitsh_urldir()
    runargs = (;
        buff_file = _tempfile(),
        run_fun = _run,
        ios = [strdout]
    )
    
    # gitsh
    url = _get_url()
    gitsh = _gitsh_urldir(url)

    _git = joinpath(gitsh, ".git")
    if isdir(_git) 
        _try() do
            if force
                pid, out = _run_bash([ git_startup;
                    "git -C '$gitsh' fetch";
                    "git -C '$gitsh' reset --hard FETCH_HEAD"
                ]; runargs... )
            else
                pid, out = _run_bash([ git_startup;
                    "git -C '$gitsh' pull";
                    "git -C '$gitsh' reset --hard FETCH_HEAD"
                ]; runargs... )
            end
        end 
    else
        _try() do
            gitsh_cmd("clone", url, gitsh; gitsh, verb)
        end
    end
end

## ---------------------------------------------------------------
# TODO: connect with config
function _clone_gitsh(;verb = false)

    # gitsh
    url = _get_url()
    gitsh = _gitsh_urldir(url)

    _try() do
        gitsh_cmd("clone", url, gitsh; gitsh, verb)
    end
end