function _make_server_script(;sys_root, url)
    file = _localdir(".temp", "reset_script.jl")

    src = """
    import GitWorkers

    rm("$(file)"; force = true)

    GitWorkers.run_server(; sys_root = "$(sys_root)", url = "$(url)")

    """

    write(file, src)

    return file
end


function _reset_server()
    _repo_update() do
        _send_killsig(getpid())
    end
    proj = Base.active_project()
    script = _make_server_script(;sys_root = _get_root(), url = _get_url())
    !isfile(script) && return
    cmd = Cmd(["julia", "--startup-file=no", "--project=$(proj)", "-e", script])
    cmd = Cmd(cmd; detach = true)
    run(pipeline(cmd, stdout=stdout, stderr=stderr; append = false), wait=false)
end