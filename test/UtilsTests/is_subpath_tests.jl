function is_subpath_tests()
    dir = pwd() |> abspath
    @test GW.is_subpath(dir |> dirname, dir)
    @test !GW.is_subpath(dir, dir |> dirname)
end
is_subpath_tests()