# git ls-files

function _force_gitignore()
    gitignore = _repodir(".gitignore")
    !isfile(gitignore) && touch(gitignore)
    _on_content_event(gitignore; dofirst = true) do
        write(gitignore, 
            """
            # This file is machine generated.
            # Any change will be overwritten
            # Ignore all
            *
            */*
            !/$(_GITWR_GLOBALDIR_NAME)
            !/$(_GITWR_GLOBALDIR_NAME)/*
            !.gitignore
            """
        )
    end
end