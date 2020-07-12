function summary_task(taskname; indent = 4)
    println("Task name: ", taskname)
    for (name, data) in [("ORIGIN_CONFIG", ORIGIN_CONFIG), 
            ("LOCAL_STATUS", LOCAL_STATUS)]
        println(name)
        if haskey(data, taskname)
            JSON.print(data[taskname], indent)
            println()
        else
            println("\tNo data available")
        end
    end
end