function wait_for(fun; frec = 10, wtime = 10)
    iters = floor(Int, wtime * frec)
    for i in 1:iters
        fun() && return
        sleep(1/frec)
    end
end