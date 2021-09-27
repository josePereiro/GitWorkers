function _update_urlproject()
    println("\n\n")
    @info("Updating")
    Pkg.activate(_urldir())
    Pkg.update()
end

function _server_loop_exit()
    _exec_killsigs()
    exit()
end