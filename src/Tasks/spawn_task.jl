_temp_script_file(cmdid) = joinpath(_gitwr_tempdir(), string(cmdid, ".script.jl"))

function _exec_cmd(cmd_file; verb = false)

    !isfile(cmd_file) && return
    
    cmdid = _extract_cmd_id(cmd_file)
    
    # config
    wdir = _load_config!("wdir", homedir())

    println("\n"^5)
    @info("running comds", cmdid)

    
    # script
    script_file = _temp_script_file(cmdid)
    
    # register
    _reg_todel(script_file, cmd_file)

    write(script_file, 
        """
            cd("$wdir")
            using Serialization
            
            # files
            cmd_file = "$cmd_file"
            script_file = "$script_file"

            try 
                
                # load ex
                !isfile(cmd_file) && return
                ex = deserialize(cmd_file)

                # eval
                eval(ex);
                
            catch err
                @warn("ERROR", err)
                rethrow(err)
            end
        """
    )

    # TODO: connect with config
    # cmd = Cmd(`$(Base.julia_cmd()) --startup-file=no $(script_file)`; detach = false)
    cmd = Cmd(`$(Base.julia_cmd()) --startup-file=no $(script_file)`; detach = true)
    # _long_run(cmd)
    # _run(cmd; verb = true)
    run(cmd; wait = false)

    println("\n"^5)
    
end