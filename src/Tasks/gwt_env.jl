function _gen_temp_env(envdir)
    
    mkpath(envdir)
    
    # proj
    gwtproj = joinpath(envdir, "Project.toml")
    write(gwtproj,
        string(
            "[deps]", "\n",
            "GitWorkers = \"9e5d5e8c-ba81-11ea-39e8-15323c797f61\"", "\n"
        )
    )

    # manif (The same as GitWorkers)
    gw_pkgdir = pkgdir(GitWorkers)
    gwmanf = joinpath(gw_pkgdir, "Manifest.toml")
    gwtmanf = joinpath(envdir, "Manifest.toml")
    _cp(gwmanf, gwtmanf)

    return envdir
end