_temp_script_file(cmdid) = joinpath(_gitsh_tempdir(), string(cmdid, ".script.jl"))

function _exec_cmd(cmd_file; verb = false)

    cmdid = _extract_cmd_id(cmd_file)
    
    !isfile(cmd_file) && return

    _locked_sync_gitsh!(cmdid; verb) do
        # config
        wdir = _load_config!("wdir", homedir())

        println("\n"^5)
        @info("running comds", cmdid)

        # script
        script_file = _temp_script_file(cmdid)
        write(script_file, 
            """
                cd("$wdir")
                using Serialization
                
                # files
                cmd_file = "$cmd_file"
                script_file = "$script_file"
                rm(script_file; force=true)

                try 
                    
                    # load ex
                    !isfile(cmd_file) && return
                    ex = deserialize(cmd_file)
                    rm(cmd_file; force=true)

                    # eval
                    eval(ex);
                catch err
                    @warn("ERROR", err)
                    rethrow(err)
                finally
                    rm(cmd_file; force=true)
                    rm(script_file; force=true)
                end
            """
        )

        # TODO: connect with config
        # cmd = Cmd(`$(Base.julia_cmd()) --startup-file=no $(script_file)`; detach = false)
        cmd = `$(Base.julia_cmd()) --startup-file=no $(script_file)`
        # _long_run(cmd)
        # _run(cmd; verb = true)
        run(cmd; wait = true)
        
        println("\n"^5)
    
    end # _locked_sync_gitsh
end