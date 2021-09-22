const _TODEL = String[]
const _TODEL_LK = ReentrantLock()

function _reg_todel(fn, fns...) 
    lock(_TODEL_LK) do
        push!(_TODEL, fn, fns...)
    end
end

function _delall()
    lock(_TODEL_LK) do
        for _ in eachindex(_TODEL)
            rm(pop!(_TODEL); recursive = true, force = true)
        end
    end
end