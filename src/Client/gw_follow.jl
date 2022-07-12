function gw_follow(gw::GitWorker = gw_curr(), rtrt::GWTaskRunTime = gw_curr_task())

    @info("Following")
    _pull_and_listen(gw, rtrt) 
end