function _expr_src(ex::Expr)
    buf = IOBuffer()
    Base.show_unquoted(buf, ex)
    src = String(take!(buf))
    return replace(src, r"#.*#\n" => "")
end

macro expr_src(ex)
    _expr_src(ex) |> println
end