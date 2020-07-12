function summary_task(taskname; tab = "   ")
    println("Task name: ", taskname)
    for (name, data) in [("ORIGIN_CONFIG", ORIGIN_CONFIG), 
            ("LOCAL_STATUS", LOCAL_STATUS)]
        println(name)
        if haskey(data, taskname)
            for (k, info) in data[taskname]
                if info isa Dict
                    println(tab, k, ":")
                    for (k, val) in info
                        println(tab^2, k, ": ", isnothing(val) ? "" : val)
                    end
                else
                    println(tab, k, ": ", info)
                end
            end
        else
            println("\tNo data available")
        end
    end
end