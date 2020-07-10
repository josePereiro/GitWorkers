function git_find_tests()

    # Test repo
    root = "TestRoot" |> abspath
    rm(root; force = true, recursive = true)
    @assert mkdir(root) |> isdir
    git_dir = joinpath(root, GW.GIT_DIR_NAME)
    @assert mkdir(git_dir) |> isdir
    not_git_dir = joinpath(root, "NOT_" * GW.GIT_DIR_NAME)
    @assert mkdir(not_git_dir) |> isdir

    test_file = "test_file"
    deep_file = joinpath(root, fill("sub", 10)..., test_file) 
    to_finds = map(0:rand(3:8)) do i
        return joinpath(root, fill("sub", i)..., test_file) |> abspath
    end 
    to_finds = [to_finds; deep_file] .|> abspath |> sort 
    @assert issorted(to_finds)
    foreach(GW.create_file, to_finds)
    @test all(isfile.(to_finds))
    @assert all(isabspath.(to_finds))
    not_to_find = "\n"
    @assert !isfile(not_to_find)

    # find_reporoot
    @test GW.find_reporoot(deep_file) == root

    
    # findall_repo
    founds = GW.findall_repo(test_file, deep_file)
    @test all(founds |> sort .== to_finds)
    @test GW.findall_repo(not_to_find, deep_file) |> isempty

    # findin_repo
    @test GW.findin_repo(test_file, deep_file) in to_finds
    @test GW.findin_repo(not_to_find, deep_file) |> isnothing

    # findup_repo
    @show GW.findup_repo(test_file, deep_file) in to_finds

    # clearing
    rm(root; force = true, recursive = true)

end
git_find_tests()