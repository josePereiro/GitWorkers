ORIGIN_CONFIG_FILE_NAME = "gitworker.origin-config.json"
CONTROL_FILES_HEAD_COMMENT = "This file is machine-generated - editing it directly is not advised"
LOCAL_STATUS_FILE_NAME = "gitworker.local-status.json"

"""
    This will contains the current configuration from origin.
    This is fetched from the $ORIGIN_CONFIG_FILE_NAME worker file
"""
ORIGIN_CONFIG = Dict()
LOCAL_STATUS = Dict()