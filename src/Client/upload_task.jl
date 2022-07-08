# TASK LAYOUT
# GWTaskRunTime.toml
# out.log
# status.txt
# dat.jls
# README.md
# task_runme.jl

function _write_task(gw::GitWorker, tname; dat...)

    trt = create_task(gw, tname; write = false)
    
    try 
        
        # create temp local task
        mkpath(trt)

        write_toml_file(trt)  # GWTaskRunTime.toml
        write_status(trt, NEW_STATUS) # status.txt
        serialize(dat_file(trt), Dict(pairs(dat)...)) # dat.jls
        touch(readme_file(trt)) # README.md

        # copy to repo
        _cp(agent_dir(trt), repo_path(trt))
    
    finally
        _rm(agent_dir(trt))
    end

    return repo_agent(trt)

end

function _upload_task(gw::GitWorker, tname; dat...)

    # upload
    trt = nothing
    upload_wdir(gitlink(gw); verbose = false) do _

        # repo agent
        trt = _write_task(gw, tname; dat...)

    end

    return trt

end