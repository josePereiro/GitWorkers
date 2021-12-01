let

    for (runner_cmd, src_name) in [
            ["julia --startup-file=no ", "test_script.jl"],
            ["bash -c", "test_script.sh"],
        ]

        src_file = joinpath(@__DIR__, src_name)
        outfile = joinpath(tempname(), "out.log")
        GW._rm(outfile)
        GW._mkdir(outfile)
        GW._spawn_bash("$(runner_cmd) $(src_file) 2>&1 | tee $(outfile)")

        cat = ""
        done_flag = false
        for _ in 1:15
            println("-"^60)
            println(basename(src_file))
            if isfile(outfile) 
                cat = read(outfile, String)
                println(cat)
            end
            done_flag = contains(cat, "DONE") 
            done_flag && break
            sleep(1.0)
        end
        @assert done_flag
        GW._rm(outfile)
    end
end

