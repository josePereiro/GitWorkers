struct GWDeamon <: AbstractWorker
    # System
    sys_root::String

    # Worker
    worker_root::String
    dat::Dict{Any, Any}

    function GWDeamon(sys_root)
        wroot = _deamon_dir(sys_root)
        return new(sys_root, wroot, Dict{Any, Any}())
    end

end

sys_root(d::GWDeamon) = d.sys_root