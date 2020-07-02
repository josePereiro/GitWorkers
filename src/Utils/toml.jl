# Force single toml files
TOML_DICT_TYPE = Dict{String, Union{String, Number}}

function toml_commtstr(lines)
    tempio = IOBuffer();
    foreach(lines) do line
        line = isempty(line) ? "" : "# " * line
        println(tempio, line)
    end
    return String(take!(tempio))
end

function write_toml(file, dict; 
        headcmmts = [],
        keycmmts = Dict(),
    )
    
    dict = TOML_DICT_TYPE(dict)
    tempio = IOBuffer();
    
    # head lines
    headstr = toml_commtstr(headcmmts)
    println(tempio, headstr)

    # key
    for kv in dict
        (k, val) = kv
        cmmtstr = get(keycmmts, k, []) |> toml_commtstr
        !isempty(cmmtstr) && print(tempio, cmmtstr)
        TOML.print(tempio, kv |> Dict)
        TOML.println(tempio)
    end
    
    toml_str = String(take!(tempio))
    # close(tempio)
    
    open(file, "w") do io
        println(io, toml_str)
    end

end

read_toml(file) = TOML_DICT_TYPE(TOML.parsefile(file))