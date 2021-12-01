let
    file = tempname()
    
    try
        gwt = GW.GWTask("TASK1", "HOME")
        GW._rm(file)
        GW._mkdir(file)
        open(file, "w") do io
            redirect_stdout(io) do
                GW._print_eotask(gwt)
            end
        end
        out = read(file, String)
        println(out)
        m = match(GW._TASK_EOTASK_REGEX, out)
        @test !isnothing(m)
    finally
        GW._rm(file)
    end
end