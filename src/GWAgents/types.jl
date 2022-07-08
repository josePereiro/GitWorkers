abstract type AbstractGWAgent end


struct GWDeamon <: AbstractGWAgent
    dat::Dict

    function GWDeamon(sys_root::AbstractString; write = true)
        dm = new(Dict{Any, Any}())
        set!(dm, :agent_dir, deamon_dir(sys_root))
        write && write_toml_file(dm)
        return dm
    end

end


struct GitWorker <: AbstractGWAgent
    dat::Dict

    function GitWorker(
            remote_url::AbstractString, 
            sys_root::AbstractString; 
            write = true
        )
        gw = new(Dict{Any, Any}())
        set!(gw, :remote_url, remote_url)
        set!(gw, :agent_dir, worker_dir(sys_root, remote_url))
        write && write_toml_file(gw)
        return gw
    end

end


struct GWTaskRunTime <: AbstractGWAgent
    dat::Dict

    function GWTaskRunTime(
            task_dir::AbstractString; 
            write = true
        )
        trt = new(Dict{Any, Any}())
        set!(trt, :agent_dir, task_dir)
        write && write_toml_file(trt)
        return trt
    end

end