"""
    Store the information of the control keys.
    Mainly type and description.
"""
# CONTROL_MANIFEST = Dict()
# CONTROL_TYPE_KEY = "type"
# CONTROL_DESC_KEY = "description"

EXE_ORDER_KEY = "exe_order"
# CONTROL_MANIFEST[EXE_ORDER_KEY] = Dict(
#     CONTROL_TYPE_KEY => Int,
#     CONTROL_DESC_KEY => "Main control of tasks execution state, represent the current execution orider"
# )

EXE_ORDER_STATE_KEY = "$(EXE_ORDER_KEY)_state"
# CONTROL_MANIFEST[EXE_ORDER_STATE_KEY] = Dict(
#     CONTROL_TYPE_KEY => Bool,
#     CONTROL_DESC_KEY => "The state of the $EXE_ORDER_KEY as resolved by the TaskManager from the control files state."
# )

EXE_ORDER_STATE_INFO_KEY = "$(EXE_ORDER_STATE_KEY)_info"
# CONTROL_MANIFEST[EXE_ORDER_STATE_INFO_KEY] = Dict(
#     CONTROL_TYPE_KEY => String,
#     CONTROL_DESC_KEY => "Further info describing $EXE_ORDER_STATE_KEY"
# )

LAST_EXE_ORDER_KEY = "last_$(EXE_ORDER_KEY)"
# CONTROL_MANIFEST[LAST_EXE_ORDER_KEY] = Dict(
#     CONTROL_TYPE_KEY => Int,
#     CONTROL_DESC_KEY => "Set the last execution order, "*
#         "used to resolve if a execution order was already executed"
# )

KILL_SIGN_KEY = "kill_sign"
KILL_SIGN = "kill"
NOT_KILL_SIGN = "not_kill"

# CONTROL_MANIFEST[KILL_SIGN_KEY] = Dict(
#     CONTROL_TYPE_KEY => String,
#     CONTROL_DESC_KEY => "Main control of tasks kill state, "*
#         "if present the task will be killed or never run"
# )

KILL_ORDER_STATE_KEY = "$(KILL_SIGN_KEY)_state"
# CONTROL_MANIFEST[KILL_ORDER_STATE_KEY] = Dict(
#     CONTROL_TYPE_KEY => Bool,
#     CONTROL_DESC_KEY => "The state of the $KILL_SIGN_KEY as resolved by the TaskManager from the control files state."
# )

KILL_ORDER_STATE_INFO_KEY = "$(KILL_ORDER_STATE_KEY)_info"
# CONTROL_MANIFEST[KILL_ORDER_STATE_INFO_KEY] = Dict(
#     CONTROL_TYPE_KEY => String,
#     CONTROL_DESC_KEY => "Further info describing $KILL_ORDER_STATE_KEY"
# )
