_gitwr_CMD_EXT = ".gitworker.cmd"
const _ID_ALPHABET_ = join(['a':'z'; 'A':'Z'; '0':'9'])
const _ID_LENGTH_ = 8

_rand_cmd_id() = join(rand(_ID_ALPHABET_, _ID_LENGTH_))

_gitwr_cmd_file(cmdid) = joinpath(_gitwr_urldir(), string(cmdid, _gitwr_CMD_EXT))

_is_cmd_file(fn) = endswith(fn, _gitwr_CMD_EXT)

_find_cmds() = _filter_gitwr(_is_cmd_file)

_extract_cmd_id(fn) = replace(basename(fn), _gitwr_CMD_EXT => "")