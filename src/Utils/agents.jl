function _cached_map!(f::Function, gw::AbstractGWAgent, curr_key, cache_key::Symbol, init_fun::Function)
    cache = get!(init_fun, gw, cache_key)
    if !haskey(cache, curr_key)
        new_val = f()
        cache[new_val] = curr_key
        cache[curr_key] = new_val
    end
    return cache[curr_key]
end

function _collect_tasks!(tasks::Dict, tdir)

    toml_name = toml_file_name(GWTaskRunTime)
    for path in _readdir(tdir; join = true)
        isdir(path) || continue
        gw_toml_file = joinpath(path, toml_name)
        isfile(gw_toml_file) || continue
        get!(tasks, gw_toml_file) do
            read_toml_file(GWTaskRunTime, gw_toml_file)
        end
    end

    return tasks
end