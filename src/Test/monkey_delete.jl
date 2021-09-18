function _monkey_delete(repo_dir::String, frec::Float64; verb = true)
    frec < rand() || return
    for (root, _, files) in walkdir(repo_dir)
        for file in files
            frec > rand() && continue
            rfile = joinpath(root, file)
            rm(rfile; recursive = true, force = true)
            verb && println("monkey deleted!! ", rfile)
        end
    end
end