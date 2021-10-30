function gw_sysdir()
    root = _repodir()
    println("repo: ")
    println("   ", root)
    println()
    for name in readdir(root; join = false)
        name == ".git" && continue
        path = joinpath(root, name)
        if isdir(path)
            println("-"^60)
            println(basename(path), ": ")
            for subpath in readdir(path; join =  true)
                !isfile(subpath) && continue
                println("   ", subpath)
            end
            println()
        end

    end
end