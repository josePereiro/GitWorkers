function _spawn_task_script(rscfile::String; 
        outfile = joinpath(dirname(rscfile), "out.log"),
        deb = false, 
        ignorestatus = true, 
        detach = false
    )

    shline = "julia --startup-file=no '$(rscfile)' 2>&1 | tee '$(outfile)'"
    cmd = Cmd(`bash -c $(shline)`; ignorestatus, detach)
    proc = run(cmd; wait = deb)
    return _try_getpid(proc)

end