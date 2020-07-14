function check_gitignores(path = pwd())
    gitignores = findall_repo(GITIGNORE_FILE_NAME, path)
    isempty(gitignores) && error("Any $(GITIGNORE_FILE_NAME) files found!!!")
    for gitignore in gitignores
        lines = readlines(gitignore);
        for rule in GITWORKER_GITIGNORE_SECTION_RULES
            !(rule in lines) && error("One madatory rule '$rule' missing in '$(relpath_repo(gitignore))' file!!!")
        end
    end
end

function create_gitignore(path = pwd(); force = false)
    workerroot = path |> find_ownerworker |> get_workerroot
    gitignore = joinpath(workerroot, GITIGNORE_FILE_NAME)
    isfile(gitignore) && !force && error("$(relpath_repo(gitignore)) already exist!!!")
    txts = join([GITWORKER_GITIGNORE_SECTION_DELIM; GITWORKER_GITIGNORE_SECTION_MSG; GITWORKER_GITIGNORE_SECTION_RULES], "\n")
    write(gitignore, txts)
    return gitignore
end