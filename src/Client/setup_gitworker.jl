## ---------------------------------------------------------------
# TODO: connect with config
# init setup
function setup_gitworker(;
        url::AbstractString,
        sys_home::AbstractString = homedir(),
        verb::Bool = false
    )

    # global
    _set_url!(url)
    _set_root!(sys_home)
    
    # pull
    _pull_gitwr(;verb, force = false)

    # config
    if !_has_config()
        _locked_sync_gitwr!(:CLIENT; verb) do
            _save_config(_default_config())
        end
    end

end
