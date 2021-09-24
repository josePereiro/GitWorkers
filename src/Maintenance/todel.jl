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
            _gwrm(pop!(_TODEL))
        end
    end
end