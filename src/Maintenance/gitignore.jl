function _force_gitignore()
    gitignore = joinpath(_gitwr_urldir(), ".gitignore")
    return _on_content_event(gitignore) do
        write(gitignore, 
            """
            # This file is machine generated.
            # Any change will be overwritten
            /$(_GITWR_TEMPDIR_NAME)
            /$(_GITWR_LOCALDIR_NAME)
            /$(_GITWR_STAGEDIR_NAME)
            """
        )
    end
end