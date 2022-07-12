function _run_task(tdir::AbstractString)

    ## -----------------------------------------------------
    # globals
    trt = read_toml_file(GWTaskRunTime, tdir)
    isnothing(trt) && error("Unable to load task, task_dir: ", tdir)
    
    gw_curr_task!(trt)
    
    __run_os = Ref(true)
    __os = nothing
    status = RUNNING_STATUS

    try

        # TASK OS
        __os = @async while __run_os[]

            # Maintinance
            write_status(trt, status)
            write_proc_reg(trt)
            safe_killall(trt)

            # LOG RUNNING
            log_info(trt, 
                "TASK RUNNING";
                task_id = agent_ider(trt),
                pid = getpid(),
            )

            _flush_all()

            sleep(3.0)
        end

        # PRINT WELCOME > out.log
        println("RUNNING TASK ", ">"^40)
        println("task_id: ", agent_ider(trt))
        println("pid:     ", getpid())
        println("pwd:     ", pwd())
        println("<"^53)
        println()
        _flush_all()

        # LOG WELCOME > out.log
        log_info(trt, 
            "HELLO FROM TASK";
            task_id = agent_ider(trt),
            pid = getpid(),
            root_dir = agent_dir(trt),
        )
        _flush_all()

        # RUN EX
        __dat_file = dat_file(trt)
        isfile(__dat_file) || error("dat file not found: dat_file: ", __dat_file)
        __task_dat = deserialize(__dat_file)
        __ex = get(__task_dat, :ex, nothing)
        isnothing(__ex) && error("ex data missing: dat_file: ", __dat_file)
        Main.eval(__ex)

        # DONE
        status = DONE_STATUS
        
        _flush_all();

    catch err
        
        status = ERROR_STATUS
        write_status(trt, status)
        
        # PRINT ERROR
        println("\n\nERROR CAPTURED:")
        println(_err_str(err))
        _flush_all();

        # LOG ERROR
        log_error(trt, 
            "AT EXECUTING EX";
            task_id = agent_ider(trt),
            pid = getpid(),
            err = _err_str(err)
        )

        sleep(3.0)
        rethrow(err)

    finally

        # STOP OS
        __run_os[] = false
        isnothing(__os) || wait(__os)

        # PRINT FINISHED > out.log
        println("\n\n")
        println("TASK FINISHED ", ">"^40)
        println("task_id: ", agent_ider(trt))
        println("pid:     ", getpid())
        println("status:  ", status)
        println("<"^54)
        println()

        # LOG FINISHED
        write_status(trt, status)
        log_info(trt, 
            "TASK FINISHED";
            task_id = agent_ider(trt), 
            pid = getpid(),
            status
        )
        _flush_all();
        sleep(3.0)
        
    end


end