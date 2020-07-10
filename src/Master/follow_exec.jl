function follow_exec(path = pwd(); wt = 10, init_margin = 50)
    ownertask = find_ownertask(path)
    taskroot = ownertask |> get_taskroot
    
    l0 = Dict()
    stdout_file = joinpath(taskroot, LOCAL_FOLDER_NAME, "stdout.txt")
    l0[stdout_file] = !isfile(stdout_file) ? 1 : max(1, length(readlines(stdout_file)) - init_margin)
    stderr_file = joinpath(taskroot, LOCAL_FOLDER_NAME, "stderr.txt")
    l0[stderr_file] = !isfile(stderr_file) ? 1 : max(1, length(readlines(stderr_file)) - init_margin)


    while true

        try
            # Pulling
            wait(run(`git pull`, wait = false))
            last_file = nothing
            for (file, color_) in [(stdout_file, :blue), (stderr_file, :red)]
                !isfile(file) && continue

                l0_ = l0[file]
                lines = readlines(file)
                length(lines) <= l0_ && continue 

                bn = basename(file)
                last_file != file && println()
                for (i, line) in lines[l0_:end] |> enumerate
                    printstyled("[", bn, "] ", l0_ + i - 1, ":  ", color = color_)
                    println(line)
                end
                l0[file] = length(lines) + 1
                last_file = file
            end

            sleep(wt)
        catch err
            err isa InterruptException && return
            rethrow(err)
        end
    end

end