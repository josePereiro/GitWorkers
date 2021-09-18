_GITSH_CMD_EXT = ".gitsh.cmd"
const _ID_ALPHABET_ = join(['a':'z'; 'A':'Z'; '0':'9'])
const _ID_LENGTH_ = 8

_rand_cmd_id() = join(rand(_ID_ALPHABET_, _ID_LENGTH_))

_gitsh_cmd_file(cmdid) = joinpath(_gitsh_urldir(), string(cmdid, _GITSH_CMD_EXT))

_is_cmd_file(fn) = endswith(fn, _GITSH_CMD_EXT)

_find_cmds() = filter_gitsh(_is_cmd_file)

_extract_cmd_id(fn) = replace(basename(fn), _GITSH_CMD_EXT => "")