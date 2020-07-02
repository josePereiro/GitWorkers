function write_toml(file, toml_dict::Dict; 
        headlines = [])
    
    tempio = IOBuffer();
    
    # head lines
    foreach(headlines) do line
        line = isempty(line) ? "" : "# " * line
        println(tempio, line)
    end
    TOML.print(tempio, toml_dict)
    toml_str = String(take!(tempio))
    close(tempio)
    
    open(file, "w") do io
        println(io, toml_str)
    end
end

read_toml(file) = TOML.parsefile("test.toml")