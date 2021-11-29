function _flush()
    Base.flush(stdout)
    Base.flush(stderr)
    Base.Libc.flush_cstdio()
end