function send_push_token(token::Bool, path = pwd(); 
        info = "Sent by master",
        deb = false, verbose = true)

    # checks
    check_gitignores(path)

    worker = find_ownerworker(path)
    name = get_workername(worker)
    msg = """Master to $name: $(token ? "push!!!" : "shut up!!!")"""
    master_update(worker; commit_msg = msg, deb = deb, verbose = verbose,

        before_push = function(worker)
            verbose && print_title("SET PUSH TOKEN")
            verbose && println("BEFORE")
            verbose && pretty_print(Dict(PUSH_TOKEN_KEY => get_config(PUSH_TOKEN_KEY)))

            set_config(token, PUSH_TOKEN_KEY, VALUE_KEY)
            set_config(info, PUSH_TOKEN_KEY, INFO_KEY)
            set_config(now(), PUSH_TOKEN_KEY, UPDATE_DATE_KEY)
            
            verbose && println("NOW")
            verbose && pretty_print(Dict(PUSH_TOKEN_KEY => get_config(PUSH_TOKEN_KEY)))
        end
    )

    return token
end