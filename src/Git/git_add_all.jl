# TODO: Use LibGit2
function git_add_all() 
    try
        run(Cmd(`git add --all`))
        return true
    catch
        return false
    end
end