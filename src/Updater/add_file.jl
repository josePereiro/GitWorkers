function add_file(file, tries = 5, maxwt = 1)
    !isfile(file) && return false
    try
        # TODO: Use LibGit2
        run(Cmd(`git add -f -- $file`))
        log("File $file added") # TODO: regulate frec
    catch err
        log(err)
        err isa InterruptException && rethrow(err)
        sleep(maxwt * rand())
        tries <= 0 && return false
        add_file(tries - 1, maxwt)
    end
    return true
end