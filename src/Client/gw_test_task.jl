function gw_test_task(iters = 120; follow = true)

    expr = quote
        begin

            println("Test task started at ", GitWorkers.Dates.now())
            for it in 1:$(iters)
                println("Iter ", it, " of ", $(iters))
                sleep(1.0)
                flush(stdout)
                flush(stderr)
            end
            print("\n\n")

        end
    end
    gw_spawn(expr; follow)

    return nothing
end