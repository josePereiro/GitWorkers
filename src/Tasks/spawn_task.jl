function _spawn_runme(gwt::GWTask; wait = false)

    mkpath(gwt)
    runme = _runme_file(gwt)
    out_log = _taskout_file(gwt)
    projdir = _gen_temp_env(tempdir())
    julia = _julia_cmd_str()
    jlcmd = "$(julia) --startup-file=no --project=$(projdir) $(runme) -- -w 2>&1 > $(out_log)"
    bashcmd = Cmd(
        `bash -c $(jlcmd)`; 
        dir = homedir()
    )
    run(bashcmd; wait)

    return gwt

end