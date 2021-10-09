## ------------------------------------------------------------------------------
function _filelog_formater(io, args)
    println(io)
    println(io, args.level, " | ", args.message)
    for (k, v) in args.kwargs
        println(io, string(k), ":")
        println(io, string(v))
    end
end

_scape_all(str::AbstractString) = isempty(str) ? "" : string("\\", join(str, "\\"))

function _log_format_name(tag, date_format, ext)
    tag_part = isempty(tag) ? "" : string(_scape_all(tag), ".")
    ext_part = isempty(ext) ? "" : string(".", _scape_all(ext))
    string(tag_part, date_format, ext_part)
end

_log_format_name(tag, ext) = _log_format_name(tag, "YYYY-mm-dd-HH", ext)

_rotating_logger(logdir, nametag, ext) = DatetimeRotatingFileLogger(_filelog_formater, logdir, _log_format_name(nametag, ext))

_tee_logger(logdir, nametag, ext) = TeeLogger(
    _rotating_logger(logdir, nametag, ext),
    global_logger()
)

## ------------------------------------------------------------------------------