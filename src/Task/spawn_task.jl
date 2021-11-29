# TODO: eval use -f flag (?)
#=
-f, --flush
     Flush output after each write.  This is nice for telecooperation: one person
     does 'mkfifo foo; script -f foo', and another can supervise real-time what is
     being done using 'cat foo'. 
=#

function _spawn_bash(shline::String;
        deb = false, 
        ignorestatus = true, 
        detach = false
    )
    cmd = Cmd(`bash -c $(shline)`; ignorestatus, detach)
    proc = run(cmd; wait = deb)
    return _try_getpid(proc)
end

_dflt_outfile(rscfile) = joinpath(dirname(rscfile), "out.log")

function _spawn_shscript(rscfile::String; 
        outfile = _dflt_outfile(rscfile),
        kwargs...
    )
    chmod(rscfile, 0o755)
    shline = "bash -c '$(rscfile)' 2>&1 | tee '$(outfile)'"
    return _spawn_bash(shline; kwargs...)
end

function _spawn_jlscript(rscfile::String; 
        outfile = _dflt_outfile(rscfile),
        kwargs...
    )

    shline = "julia --startup-file=no '$(rscfile)' 2>&1 | tee '$(outfile)'"
    return _spawn_bash(shline; kwargs...)
end

function _spawn_script(rscfile::String; 
        outfile = _dflt_outfile(rscfile),
        kwargs...
    )
    if endswith(rscfile, ".jl")
        _spawn_jlscript(rscfile; outfile, kwargs...)
    else
        _spawn_shscript(rscfile; outfile, kwargs...)
    end
end