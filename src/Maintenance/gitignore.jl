function _force_gitignore()
    gitignore = joinpath(_gitsh_urldir(), ".gitignore")
    return _on_content_event(gitignore) do
        write(gitignore, 
            """
            # This file is machine generated.
            # Any change will be overwritten
            /$(_GITSH_TEMPDIR_NAME)
            /$(_GITSH_LOCALDIR_NAME)
            /$(_GITSH_STAGEDIR_NAME)
            """
        )
    end
end