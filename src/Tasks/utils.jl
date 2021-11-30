function _fatal_err(gwt::GWTask, f::Function)
    try; f()
    catch err
        GitWorkers._printerr(err)
        GitWorkers._flush()
        sleep(2.0) # time for flusing
        exit()
    end
end