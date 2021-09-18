const _ID_ALPHABET_ = join(['a':'z'; 'A':'Z'; '0':'9'])
const _ID_LENGTH_ = 8

_gen_id(name=""; abc = _ID_ALPHABET_, tlen = _ID_LENGTH_) = join([name; rand(abc, tlen)])