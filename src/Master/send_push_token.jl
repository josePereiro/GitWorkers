function send_push_token(token::Bool, path = pwd(); 
        info = "Sent by master",
        deb = false, verbose = true)

    worker = find_ownerworker(path)

    set_config(token, PUSH_TOKEN_KEY, VALUE_KEY)
    set_config(info, PUSH_TOKEN_KEY, INFO_KEY)
    set_config(now(), PUSH_TOKEN_KEY, UPDATE_DATE_KEY)

    write_config(worker; create = true)

    if !deb
        name = get_workername(worker)
        msg = token ? "Master to $name: push!" : "Master to $name: Shut up!"
        push_as_master(worker; commit_msg = msg)
    end

    return token
end