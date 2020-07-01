"""
    write_json(file, data) = write(file, JSON.json(data))
"""
write_json(file, data) = write(file, JSON.json(data))


"""
    read_json(file) = JSON.parse(read(file, String))
"""
read_json(file) = JSON.parse(read(file, String))
