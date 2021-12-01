function _fatal_err(f::Function, gwt::GWTask)
    try; f()
    catch err
        GitWorkers._printerr(err)
        GitWorkers._flush()
        sleep(2.0) # time for flusing
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