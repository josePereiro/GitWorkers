function _test_gw(sys_root = homedir())
    fake_url = "https://fake.gitworkers.test"
    return GitWorker(fake_url, sys_root)
end