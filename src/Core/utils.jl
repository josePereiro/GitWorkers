_dummy_file() = _repodir(".dummy")
_touch_dummy() = write(_dummy_file(), _gen_id())