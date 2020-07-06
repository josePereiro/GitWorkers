# TODO: Add tests
"""
    Returns the the val of key in a control file, or nothing 
    if invalid or missing. 
    The key information must be in the CONTROL_MANIFEST for
    consistency cheking.
"""
function read_control(controlfile, key; check_type = true)
    !isfile(controlfile) && return nothing
    control_dict = read_toml(controlfile)
    !haskey(control_dict, key) && return nothing
    val = control_dict[key]
    if check_type
        T = get_control_type(key)
        !(val isa T) && return nothing
    end
    return val
end
function read_control(controlfile)
    !isfile(controlfile) && return nothing
    return read_toml(controlfile)
end


"""
    Returns the the val of key in a control file, or nothing 
    if invalid or missing. 
    The key information must be in the CONTROL_MANIFEST for
    consistency cheking.
"""
function write_control(controlfile, control_dict::Dict; check_type = true)
    desc = Dict()
    for (key, val) in control_dict
        val = control_dict[key]
        if check_type
            T = get_control_type(key)
            !(val isa T) && error("Key $key ($val) invalid type '$(typeof(val))', expected '$T'")
        end
        desc[key] = get_control_desc(key)
    end
    !isfile(controlfile) && create_file(controlfile)
    write_toml(controlfile, control_dict; 
        headcmmts = CONTROL_FILES_HEAD_COMMENT,
        keycmmts = desc,
    )
end

function write_control(controlfile, key, val; check_type = true)
    !isfile(controlfile) && create_file(controlfile)
    control_dict = read_control(controlfile)
    control_dict = isnothing(control_dict) ? Dict() : control_dict
    control_dict[key] = val
    write_control(controlfile, control_dict; check_type = check_type)
end
"""
    Returns the type of a given control in the CONTROL_MANIFEST, 
    `Any` if missing or invalid.
"""
function get_control_type(key) 
    !haskey(CONTROL_MANIFEST, key) && return Any
    type = CONTROL_MANIFEST[key][CONTROL_TYPE_KEY]
    !(type isa Type) && return Any
    return type
end

"""
    Returns the desc of a given control in the CONTROL_MANIFEST, 
    empty string if missing or invalid.
"""
function get_control_desc(key) 
    !haskey(CONTROL_MANIFEST, key) && return ""
    desc = CONTROL_MANIFEST[key][CONTROL_DESC_KEY]
    !(desc isa AbstractString) && return ""
    return desc
end