function find_up_tests()

    # create test dir tree
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    root = mkdir(root)
    @assert isdir(root)
    test_file = "test_file"
    deep_file = joinpath(root, fill("sub", 10)..., test_file) 
    to_finds = map(0:rand(3:8)) do i
        return joinpath(root, fill("sub", i)..., test_file)
    end
    to_finds = [to_finds; deep_file] |> sort .|> abspath
    @assert issorted(to_finds)
    @assert all(isabspath.(to_finds))
    foreach(GW.create_file, to_finds)
    @test all(isfile.(to_finds))
    not_to_find = "\n"
    @assert !isfile(not_to_find)
    

    # Skiping errors
    @test GW.findall_up((path) -> 1, deep_file) |> isempty
    
    # Throwing errs
    @test try
        GW.findall_up((path) -> 1, deep_file, onerr = (_, _, err) -> rethrow)
        false
    catch err 
        err isa TypeError ? true : rethrow(err)
    end

    # Empty return
    @test GW.findall_up((path) -> false, deep_file)  |> isempty
    @test GW.findall_up(not_to_find, deep_file) |> isempty 
 
    # NonEmpty return
    @test GW.findall_up((path) -> true, deep_file) |> isempty |> !
    @test GW.findall_up(test_file, deep_file) |> isempty |> !

    # Empty return
    @test GW.find_up((path) -> false, deep_file) |> isnothing
    @test GW.find_up(not_to_find, deep_file) |> isnothing

    # NonEmpty return
    @test GW.find_up((path) -> true, deep_file) |> isnothing |> !
    @test GW.find_up(test_file, deep_file) |> isnothing |> !

    # Find all test files
    founds = GW.findall_up((file) -> basename(file) == test_file, deep_file; 
        retfun = (path, container) -> length(container) == length(to_finds))
    @test all(founds |> sort .== to_finds)

    rm(root; force = true, recursive = true)
end
find_up_tests()