function _spawn_runme(gwt::GWTask)

    runme = _runme_file(gwt)
    chmod(rscfile, 0o755)
end