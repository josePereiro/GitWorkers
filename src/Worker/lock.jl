import Base.lock
lock(f::Function, gw::GitWorker; kwargs...) = lock(f, gitlink(gw); kwargs...)
