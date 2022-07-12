function gw_sync(; verbose = true)

    gl = gitlink(gw_curr())
    gw_request_push(; verbose) || return false
    verbose && print("waiting...")
    while true
        if is_pull_required(gl)
            download(gl)
            verbose && println()
            verbose && @info("Sync done")
            return true
        end
        verbose && print(".")
        sleep(2.0)
    end

    return done

end