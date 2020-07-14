function summary(path = pwd(); indent = 4)
    workername = path |> find_ownerworker |> get_workername
    println("Worker name: ", workername)
    for (name, data) in [("ORIGIN_CONFIG", ORIGIN_CONFIG), 
            ("LOCAL_STATUS", LOCAL_STATUS)]

        println(name)
        if isempty(data)
            println("\tNo data available")
        else
            pretty_print(data; indent = indent)
            println()
        end
    end
end