## ---------------------------------------------------------------
# routine = [
#     (;mods=[:Main], funname = :sin, args = [2*pi], kwargs = (;)),
# ]

_nameof(n::Symbol) = n
_nameof(n::String) = Symbol(n)
_nameof(n) = nameof(n)

function _serialized_call(;
        fun,
        mods::Vector = [Main],
        args::Vector = [],
        kwargs = (;)
    )
    (;mods = _nameof.(mods), fun = _nameof(fun), args, kwargs)
end

_serialized_call(nt::NamedTuple) = _serialized_call(;nt...)

## ---------------------------------------------------------------
_parse_ret(ret::Tuple{Symbol, <:Any}) = ret
_parse_ret(ret::Any) = (nothing, ret)

## ---------------------------------------------------------------
_serialize_routine(calls::Vector{NamedTuple}, file) = serialize(file, _serialized_call.(calls))
_serialize_routine(f::Function, file) = _serialize_routine(f(), file)

## ---------------------------------------------------------------
function _exec_call(call; mod0 = Main)
    modsyms, funsym, args, kwargs = call
    mod = mod0
    for sym in modsyms
        mod = getproperty(mod, sym)
    end
    fun = getproperty(mod, funsym)
    return fun(args...; kwargs...)
end

## ---------------------------------------------------------------
function _exec_routine(routine_file; mod0 = Main)
    # TODO: This is not save: check file and routine type
    routine = deserialize(routine_file)

    dat = nothing
    i = 1
    while true

        # call control
        i > length(routine) && break
        call = routine[i]
        i += 1

        # make call
        ret = _exec_call(call)
        flag, dat = _parse_ret(ret)

        # manage flag
        flag === :EXIT && break
        flag === :GOTO && (i = dat)
    end
    return dat
end

## ---------------------------------------------------------------
_is_routine_file(fn) = isfile(fn) && endswith(fn, ".routine")
_global_routine_file(name = _gen_id()) = _globaldir(".global_routines", string(name, ".routine"))
_local_routine_file(name = _gen_id()) = _globaldir(".local_routines", string(name, ".routine"))

## ---------------------------------------------------------------
# TODO: make a system that allows to run just a partial set of routines
# but remembers the next time and 'ensures' all routines are finally run.
# This is to prevent an overtimed execution
function _exec_routines(dir; mod0 = Main)
    !isdir(dir) && return
    routine_files = readdir(dir; join = true, sort = true)
    for routine_file in routine_files
        !_is_routine_file(routine_file) && continue
        ret = _exec_routine(routine_file; mod0 = Main)

        flag, dat = _parse_ret(ret)
        flag === :EXIT && return
    end
end