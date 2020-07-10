function find_down_tests()

    # create test dir tree
    root = "TestRoot"
    rm(root; force = true, recursive = true)
    root = mkdir(root)
    @assert isdir(root)
    test_file = "test_file"
    to_finds = map(0:rand(3:8)) do i
        return joinpath(root, fill("sub", i)..., test_file) |> abspath
    end |> sort
    @assert issorted(to_finds)
    foreach(GW.create_file, to_finds)
    @test all(isfile.(to_finds))
    @assert all(isabspath.(to_finds))
    not_to_find = "\n"
    @assert !isfile(not_to_find)

    # Skiping errors
    @test GW.findall_down((path) -> 1, root) |> isempty

    # Throwing errs
    @test try
        GW.findall_down((path) -> 1, root, onerr = (_, _, err) -> rethrow)
        false
    catch err 
        err isa TypeError ? true : rethrow(err)
    end
    
    # findall
    # Empty return
    @test GW.findall_down((path) -> false, root)  |> isempty
    @test GW.findall_down(not_to_find, root) |> isempty 

    # # NonEmpty return
    @test GW.findall_down((path) -> true, root) |> isempty |> !
    @test GW.findall_down(test_file, root) |> isempty |> !

    # find
    # Empty return
    @test GW.find_down((path) -> false, root) |> isnothing
    @test GW.find_down(not_to_find, root) |> isnothing

    # NonEmpty return
    @test GW.find_down((path) -> true, root) |> isnothing |> !
    @test GW.find_down(test_file, root) |> isnothing |> !

    # Find all test files
    @test all(GW.findall_down(test_file, root) |> sort .== to_finds)

    # clearing
    rm(root; force = true, recursive = true)

end
find_down_tests()