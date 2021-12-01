function _write_task(gwt::GWTask, ex::Expr;
        desc = "", lang = "",
        src = _expr_src(ex),
        readme = false,
        vtime = _GW_DFLT_TASK_VTIME
    )

    # dir
    _mkdir(task_dir(gwt))

    # task.toml
    extime = time() + vtime
    _write_task_toml!(gwt; extime, desc)

    # taskdat.jls
    _write_task_dat!(gwt; ex, src, desc, lang)

    # readme.md
    readme && _do_readme!(gwt)

    # runme.jl
    _write_runme(gwt)

    return gwt
end