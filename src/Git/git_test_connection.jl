function git_test_connection(remote = "origin")
    try
        run(`git remote show $remote`)
        return true
    catch err
        return false
    end 
end