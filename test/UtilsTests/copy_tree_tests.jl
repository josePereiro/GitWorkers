function copy_tree_tests()
    # make trees
    root = "TestRoot"
    rm(root; force = true, recursive = true)
    root = mkdir(root)
    tree1 = joinpath(root, "tree1")
    files1 = map(0:rand(3:8)) do i
        return joinpath(tree1, fill("sub", i)..., "bla") |> abspath
    end
    foreach(GW.create_file, files1)
    @assert all(isabspath.(files1))

    tree2 = joinpath(root, "tree2")

    # Copy tree
    files2 = []
    @test begin 
        GW.copy_tree(tree1, tree2; oncopy = (src, dest) -> push!(files2, dest))
        true
    end
    @test all(isfile.(files1))
    @test all(isfile.(files2))

    # Throwing errs (force = false, dest file exist)
    @test try
        GW.copy_tree(tree1, tree2; force = false, 
            onerr = (srcfile, destfile, err) -> rethrow(err))
        false
    catch err 
        err isa ArgumentError ? true : rethrow(err)
    end

    # Non throwing errs (force = false, dest file exist)
    @test begin
        GW.copy_tree(tree1, tree2; force = false, 
            onerr = (srcfile, destfile, err) -> nothing)    
        true
    end

    # No copy
    rm(tree2; force = true, recursive = true)
    @test begin 
        GW.copy_tree(tree1, tree2; filterfun = (file) -> false)
        true
    end
    @test all(isfile.(files1))
    @test all(.!isfile.(files2))

    rm(root; force = true, recursive = true)
end
copy_tree_tests()