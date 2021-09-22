# routine = [
#     (;mods=[:Main], funname = :sin, args = [2*pi], kwargs = (;), extras = (;)),
# ]

_nameof(n::Symbol) = n
_nameof(n::String) = Symbol(n)
_nameof(n) = nameof(n)

function _serialized_call(;
        fun,
        mods::Vector = [Main],
        args::Vector = [],
        kwargs = (;),
        extras = (;)
    )
    (;mods = _nameof.(mods), fun = _nameof(fun), args, kwargs, extras)
end

## ---------------------------------------------------------------
function _exec_routine(routine::Vector; mod0 = Main)
    foreach(routine) do cmd
        modsyms, funsym, args, kwargs, extras = cmd

        mod = mod0
        for sym in modsyms
            mod = getproperty(mod, sym)
        end
        fun = getproperty(mod, funsym)
        ret = fun(args...; kwargs...)

        get(extras, :deb, false) && @show ret

        ret === :EXIT && return
    end
end

## ---------------------------------------------------------------
_UPLOAD_ROUTINES