write_json(file, dict::Dict; indent = 4) = 
    open(file, "w") do io
        JSON.print(io, dict, indent)
    end

read_json(file)::Dict = JSON.parse(read(file, String))