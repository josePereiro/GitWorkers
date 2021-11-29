function _readme(;
        tid, src, desc,
        runme, lang,
    )
    return string(
        "# ", tid, "\n\n",
        desc, "\n\n",
        "## Usage", "\n\n",
        "- Run `$(runme)` for a full reproduction", "\n",
        "- Check `out.log` for last run output", "\n",
        "- Check `run.log` for run history", "\n",
        "\n",
        "## Source code", "\n\n",
        "```$(lang)", "\n",
        src, "\n",
        "```", 
        "\n"
    )
end

_jlreadme(src::String; tid, desc = "This is a julia task from txt source") = 
    _readme(;tid, src, desc, runme = "runme.jl", lang = "julia")

_jlreadme(ex::Expr; tid, desc = "This is a julia task from exprs source") = 
    _readme(;tid, src = _expr_src(ex), desc, runme = "runme.jl", lang = "julia")

_shreadme(src::String; tid, desc = "This is a bash task from txt source") = 
    _readme(;tid, src, desc, runme = "runme.sh", lang = "bash")