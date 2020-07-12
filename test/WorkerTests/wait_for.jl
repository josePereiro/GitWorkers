function wait_for(fun; frec = 10, wtime = 10)
    t0 = time()
    while true
        time() - t0 > wtime && return
        fun() && return
        time() - t0 > wtime && return
        sleep(1/frec)
    end
end