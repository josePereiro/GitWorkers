function _test_gw(sys_root = _GW_SYSTEM_DFLT_ROOT)
    fake_url = "https://fake.gitworkers.test"
    return GitWorker(sys_root, fake_url)
end