struct SleepProgram
    t0::Ref{Float64}
    program::Vector{Pair{Real, Real}}
    SleepProgram(prog::Pair...) = new(Ref(time()), sort!(collect(prog); by = first))
end

## ------------------------------------------------------
reset!(fc::SleepProgram) = (fc.t0[] = time())

## ------------------------------------------------------
function sleep(fc::SleepProgram)

    # time
    elap = time() - fc.t0[]

    # check overtime
    progt1, wt1 = last(fc.program)
    if elap > progt1
        sleep(wt1)
        return
    end

    # check intermedia
    for (progt, wt) in fc.program
        elap > progt && continue

        sleep(wt)
        return
    end

    # just in case
    sleep(wt1)
    return
end