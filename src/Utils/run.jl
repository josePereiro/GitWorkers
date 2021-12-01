function _run(cmd::Cmd; ignorestatus = true, verbose = true)
    cmd = Cmd(cmd; ignorestatus)
    out = read(cmd, String)
    verbose && println(out)
    return out
end

function _run(cmd::String; ignorestatus = true, verbose = true)
    cmd = Cmd(`bash -c $(cmd)`)
    _run(cmd::Cmd; ignorestatus, verbose)
end

function _run_bash(cmd::String; 
        ignorestatus = true, verbose = true
        
    )
    cmd = Cmd(`bash -c $(cmd)`)
    _run(cmd::Cmd; ignorestatus, verbose)
end

# TODO: eval use -f flag (?)
#=
-f, --flush
     Flush output after each write.  This is nice for telecooperation: one person
     does 'mkfifo foo; script -f foo', and another can supervise real-time what is
     being done using 'cat foo'. 
=#

function _run_bashline(shline::String;
        wait = false,
        ignorestatus = true, 
        detach = false
    )
    cmd = Cmd(`bash -c $(shline)`; ignorestatus, detach)
    proc = run(cmd; wait)
    return _try_getpid(proc)
end

_dflt_outfile(rscfile) = joinpath(dirname(rscfile), "out.log")

function _spawn_shscript(rscfile::String; 
        outfile = _dflt_outfile(rscfile),
        kwargs...
    )
    chmod(rscfile, 0o755)
    shline = isempty(outfile) ? 
        "bash -c '$(rscfile)'" :
        "bash -c '$(rscfile)' 2>&1 | tee '$(outfile)'"
    return _run_bashline(shline; kwargs...)
end

function _spawn_jlscript(rscfile::String; 
        outfile = _dflt_outfile(rscfile),
        kwargs...
    )
    shline = isempty(outfile) ? 
        "julia --startup-file=no '$(rscfile)'" : 
        "julia --startup-file=no '$(rscfile)' 2>&1 | tee '$(outfile)'"
    return _run_bashline(shline; kwargs...)
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