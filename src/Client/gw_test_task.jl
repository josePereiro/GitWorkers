function gw_test_task(iters = 120)

    expr = quote
        begin

            println("Test task started at ", GitWorkers.Dates.now())
            for it in 1:$(iters)
                println("Iter ", it, " of ", $(iters))
                sleep(1.0)
                flush(stdout)
                flush(stderr)
            end
            println("\n\n")

        end
    end
    _gw_spawn(expr)

    return nothing
end