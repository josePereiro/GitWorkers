
const _LOCK_EXT_ = ".lock"
const _LOCK_SEP_ = "-"

function _lock_file(name, owner)
    name, owner = string(name), string(owner)
    contains(name, _LOCK_SEP_) && error("Invalid lock name `$name`")
    contains(owner, _LOCK_SEP_) && error("Invalid lock owner `$owner`")

    joinpath(_gitsh_urldir(), 
        string(name, _LOCK_SEP_, owner, _LOCK_EXT_)
    )
end

_is_lock(lk) = endswith(lk, _LOCK_EXT_)
_has_lock_name(lk, name) = _is_lock(lk) && startswith(lk, string(name, _LOCK_SEP_))

_find_locks() = filter_gitsh(_is_lock)
_find_locks(name) = filter_gitsh((path) -> _has_lock_name(basename(path), name))

function _clear_locks!(;verb::Bool = false)
    _pull_gitsh(;verb, force = false)
    lcks = _find_locks()
    rm.(lcks; force = true)
    _push_gitsh(;verb, force = true)
end

function _clear_locks!(name; verb::Bool = false)
    _pull_gitsh(;verb, force = false)
    lcks = _find_locks(name)
    rm.(lcks; force = true)
    _push_gitsh(;verb, force = true)
end

function _clear_lock!(name, owner; verb::Bool = false)
    _pull_gitsh(;verb, force = false)
    rm(_lock_file(name, owner); force = true)
    _push_gitsh(;verb, force = true)
end

function _locked_sync_gitsh!(f::Function, lkname, owner=rand(UInt); verb::Bool = false)

    # lk file
    mylk = _lock_file(lkname, owner)

    try
        # wait for lock
        # TODO: add time out
        # TODO: connect with config
        while true
            _pull_gitsh(;verb, force = false)
            curr_lks = _find_locks(lkname)

            # too many locks try to reset
            # TODO: move to maintinance
            if length(curr_lks) > 1
                _clear_locks!(;verb)
                continue
            end
            
            # lk is NOT mine
            if length(curr_lks) == 1 && !isfile(mylk)
                sleep(1.0)
                @info("Waiting for lock free")
                continue
            end

            # lk is mine
            isfile(mylk) && break

            # try to commint
            touch(mylk)
            _push_gitsh(;verb, force = true)
            
            sleep(2.0 + rand() * 3.0) # reconciliation time
        end
        
        f()
        _push_gitsh(;verb, force = true)    

    finally
        # clear lock
        _pull_gitsh(;verb, force = false)
        rm(mylk; force = true)
        _push_gitsh(;verb, force = true)
    end
end