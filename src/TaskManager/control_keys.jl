EXE_ORDER_KEY = "EXE_ORDER"
CONTROL_MANIFEST[EXE_ORDER_KEY] = Dict(
    CONTROL_TYPE_KEY => Int,
    CONTROL_DESC_KEY => "Main control of tasks execution state"
)

LAST_EXE_ORDER_KEY = "LAST_EXE_ORDER"
CONTROL_MANIFEST[LAST_EXE_ORDER_KEY] = Dict(
    CONTROL_TYPE_KEY => Int,
    CONTROL_DESC_KEY => "Set the last execution order, "*
        "used to resolve if a execution order if new"
)

KILL_SIGN = "KILL"
CONTROL_MANIFEST[KILL_SIGN] = Dict(
    CONTROL_TYPE_KEY => Int,
    CONTROL_DESC_KEY => "Main control of tasks kill state, "*
        "if present the task will be killed or never run"
)