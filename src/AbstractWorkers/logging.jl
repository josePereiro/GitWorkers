const _GW_LOGGER_KEY = "_logger"
get_logger(w::AbstractWorker) = get!(w, _GW_LOGGER_KEY) do
    ldir = logs_dir(w)
    return _tee_logger(ldir, "TEST")
end

import Logging.with_logger
with_logger(f::Function, w::AbstractWorker) = with_logger(f, get_logger(w))