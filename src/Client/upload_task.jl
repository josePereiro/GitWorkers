const _GW_STAGING_TOUT = 60.0

function _upload_jltask(gw::GitWorker,
        tid::String, ex::Expr;
        desc = "", src = _expr_src(ex),
        readme = false,
        vtime = _GW_DFLT_TASK_VTIME
    )

    tout = _GW_STAGING_TOUT
    gl = gitlink(gw)
    
    return GitLinks.writewdir(gl; tout) do _
        
    end # writewdir
end