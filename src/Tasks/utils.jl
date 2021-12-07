function _fatal_err(f::Function, gwt::GWTask)
    try; f()
    catch err
        _printerr(err)
        _print_eotask(gwt)

        _flush_all()

        if is_worker_mode(gwt) 
            _up_task_status(gwt, _GW_TASK_ERROR_STATUS)
            # TODO: del proc reg
        end

        exit()
    end
end

function _expr_src(ex::Expr)
    buf = IOBuffer()
    Base.show_unquoted(buf, ex)
    src = String(take!(buf))
    src = replace(src, r"#.*#\n" => "")
    return string("# NOTE: This source is not 'original', it was generated from an `Expr`.", "\n", src)
end

_expr_src(gwt::GWTask) = _expr_src(_task_expr(gwt))

## ------------------------------------------------------
const _GW_TASK_T0_KEY = "_T0"
_tic!(gwt::GWTask) = set!(gwt, _GW_TASK_T0_KEY, now())
_toc(gwt::GWTask) = now() - get(gwt, _GW_TASK_T0_KEY, now())

## ------------------------------------------------------
const _GW_WELCOME_TOKEN = rpad("RUNNING TASK ", 60, ">")
const _GW_EOTASK_TOKEN = rpad("END OF TASK ", 60, ">")
const _GW_HEAD_SEP = rpad("", 60, "<")

function _print_welcome(gwt::GWTask)
    _tic!(gwt)
    println(_GW_WELCOME_TOKEN)
    # println()
    println("taskid             ", task_id(gwt))
    println("pid                ", getpid())
    println("pwd                ", pwd())
    println("wroker mode        ", is_worker_mode(gwt))
    println("start time         ", now())
    # println()
    println(_GW_HEAD_SEP)
    println("\n"^2)
    _flush_all()
end

const _TASK_EOTASK_REGEX = Regex("(?<head>$(_GW_EOTASK_TOKEN))\\n(?<info>(?:.*\\n)+)(?<tail>$(_GW_HEAD_SEP))[\\s\\n]*\$")
function _print_eotask(gwt::GWTask)
    _flush_all()
    println("\n"^2)
    println(_GW_EOTASK_TOKEN)
    println("end time           ", now())
    cantime = Dates.canonicalize(Dates.CompoundPeriod(_toc(gwt)))
    println("tot time           ", cantime)
    println(_GW_HEAD_SEP)
end
