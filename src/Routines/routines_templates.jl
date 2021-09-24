function _ping_routine()

    # id = 
    _local_routine_path = GitWorkers._local_routine_file("Test") # This is in client machine
	_repo_routine_path = GitWorkers._repo_routine_file("Test") # This is in client machine

    GitWorkers._serialize_routine(_local_routine_path) do
        [
            (; fun = println, args = ["Hiiiii"]),
        ]
    end

    GitWorkers._serialize_routine(_repo_routine_path) do
        [
            (; fun = println, args = ["\n\n"]),
            (; fun = println, args = ["Hiiiii"]),
            (; fun = println, args = ["\n\n"]), 
            (; mods = [:GitWorkers], fun = :_gwrm, args = [_repo_routine_path]),
            (; mods = [:GitWorkers], fun = :_gwrm, args = [_local_routine_path])
        ]
    end
end