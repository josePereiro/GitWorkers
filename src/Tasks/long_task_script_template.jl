_GW_LONG_TASK_SCRIPT_TEMPLATE = 
"""
# This is suppost to be run in an enviroment that has GitWorkers installed
# I'll use the server environment
try; import GitWorkers
catch err
    import Pkg
    Pkg.add("GitWorkers")
    import GitWorkers
end
import GitWorkers.Serialization

## ------------------------------------------------------------------
# load task
const _GW_TASK = Serialization.deserialize("{{TASK_FILE}}")

## ------------------------------------------------------------------
# task os
_gw_isrunning = true
@async while _gw_isrunning

    # register process

    # flush
    flush(stdout)
    flush(stderr)
    sleep(5.0)
end

## ------------------------------------------------------------------
# eval expr
_rtcmd = Serialization.deserialize(_rtfile)
@sync GitWorkers.eval(_rtcmd.expr)

## ------------------------------------------------------------------
_gw_isrunning = false

## ------------------------------------------------------------------
# insist
for _ in 1:10
    flush(stdout)
    flush(stderr)
end

## ------------------------------------------------------------------
exit()

"""