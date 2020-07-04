function find_down_tests()
    # Skiping errors
    @test GW.findall_down((path) -> 1, REPOROOT) |> isempty

    # Throwing errs
    @test try
        GW.findall_down((path) -> 1, REPOROOT, onerr = (_, _, err) -> rethrow)
        false
    catch err 
        err isa TypeError ? true : rethrow(err)
    end
    
    # Empty return
    @test GW.findall_down((path) -> false, REPOROOT)  |> isempty
    @test GW.findall_down(NOT_FILENAME, REPOROOT) |> isempty 

    # NonEmpty return
    @test GW.findall_down((path) -> true, REPOROOT) |> isempty |> !
    @test GW.findall_down(TEST_FILE_NAME, REPOROOT) |> isempty |> !

    # Empty return
    @test GW.find_down((path) -> false, REPOROOT) |> isnothing
    @test GW.find_down(NOT_FILENAME, REPOROOT) |> isnothing

    # NonEmpty return
    @test GW.find_down((path) -> true, REPOROOT) |> isnothing |> !
    @test GW.find_down(TEST_FILE_NAME, REPOROOT) |> isnothing |> !

    # Find all test files
    @test length(GW.findall_down((file) -> file in TEST_FILES, pwd())) == length(TEST_FILES)

end
find_down_tests()