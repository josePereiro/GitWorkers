# TODO: add descriptions comment
# ------------------- COMMONS -------------------
OWNER_WORKER_NAME_KEY = "owner"
VALUE_KEY = "value"
UPDATE_DATE_KEY = "update_date"
INFO_KEY = "info"
PUSH_TOKEN_KEY = "push_token"

# ------------------- ORIGIN_CONFIG -------------------
EXEC_ORDER_KEY = "exe_order"
KILL_SIGN_KEY = "kill_sign"
PUSH_TOKEN_KEY = "push_token"

# ------------------- LOCAL_STATUS -------------------
EXEC_STATUS_KEY = "execution_state"
LAST_EXEC_ORDER_KEY = "last_$(EXEC_ORDER_KEY)"
KILL_STATUS_KEY = "$(KILL_SIGN_KEY)_state"
RUNNING_STATUS_KEY = "running_state"

# ------------------- VALUES -------------------
KILL_SIGN = "kill"
NOT_KILL_SIGN = "not_kill"
DEFAULT_EXEC_ORDER = 1
DEFAULT_LAST_EXEC_ORDER = 0

