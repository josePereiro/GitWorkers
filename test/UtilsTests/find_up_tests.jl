function find_up_tests()

    # Skiping errors
    @test GW.findall_up((path) -> 1, REPOLEVEL_DEEP_TESTFILE) |> isempty
    
    # Throwing errs
    @test try
        GW.findall_up((path) -> 1, REPOLEVEL_DEEP_TESTFILE, onerr = (_, _, err) -> rethrow)
        false
    catch err 
        err isa TypeError ? true : rethrow(err)
    end

    # Empty return
    @test GW.findall_up((path) -> false, REPOLEVEL_DEEP_TESTFILE)  |> isempty
    @test GW.findall_up(NOT_FILENAME, REPOLEVEL_DEEP_TESTFILE) |> isempty 

    # NonEmpty return
    @test GW.findall_up((path) -> true, REPOLEVEL_DEEP_TESTFILE) |> isempty |> !
    @test GW.findall_up(TEST_FILE_NAME, REPOLEVEL_DEEP_TESTFILE) |> isempty |> !

    # Empty return
    @test GW.find_up((path) -> false, REPOLEVEL_DEEP_TESTFILE) |> isnothing
    @test GW.find_up(NOT_FILENAME, REPOLEVEL_DEEP_TESTFILE) |> isnothing

    # NonEmpty return
    @test GW.find_up((path) -> true, REPOLEVEL_DEEP_TESTFILE) |> isnothing |> !
    @test GW.find_up(TEST_FILE_NAME, REPOLEVEL_DEEP_TESTFILE) |> isnothing |> !

end
find_up_tests()