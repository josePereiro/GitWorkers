function gw_test_task(n = 60; follow = true)
    ex = quote
        for it in 1:$(n)
            println("Testing: ", it, "/", $(n))
            sleep(1.0)
        end
    end
    _gw_spawn(gw_curr(), ex, "TEST"; follow, tout = Inf)
    return nothing
end