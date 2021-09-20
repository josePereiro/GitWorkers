_gitwr_CMD_EXT = ".gitworker.cmd"

_gitwr_cmd_file(cmdid) = joinpath(_gitwr_urldir(), string(cmdid, _gitwr_CMD_EXT))

_is_cmd_file(fn) = endswith(fn, _gitwr_CMD_EXT)

_find_cmds() = _filter_gitwr(_is_cmd_file)

_extract_cmd_id(fn) = replace(basename(fn), _gitwr_CMD_EXT => "")