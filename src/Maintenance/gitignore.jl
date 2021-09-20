function _force_gitignore()
    gitignore = _gitwr_urldir(".gitignore")
    !isfile(gitignore) && touch(gitignore)
    _on_content_event(gitignore; dofirst = true) do
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