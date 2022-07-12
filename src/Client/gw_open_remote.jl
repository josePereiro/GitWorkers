function gw_open_remote()
    url = remote_url(gw_curr())
    run(`open $(url)`)
    return
end