let

    for rsc_file in [
            joinpath(@__DIR__, "test_script.jl"),
            joinpath(@__DIR__, "test_script.sh"),
        ]
        outfile = joinpath(tempname(), "out.log")
        GW._rm(outfile)
        GW._mkdir(outfile)
        GW._spawn_script(rsc_file; outfile)

        cat = ""
        done_flag = false
        for _ in 1:15
            println("-"^60)
            println(basename(rsc_file))
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

