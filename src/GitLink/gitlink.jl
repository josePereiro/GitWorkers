const _GIT_LINK_KEY = :_git_link_key
function gitlink(gw::GitWorker)
    get(gw, _GIT_LINK_KEY) do
        GitLinks.GitLink(gitlink_dir(gw), remote_url(gw))
    end
end