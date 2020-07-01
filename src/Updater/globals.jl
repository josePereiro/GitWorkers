"""
    Will track the time just before of the current 
    succefull pull try
"""
curr_pull_start_time = -1
"""
    Will track the start time of the last succefull pull
    before the current
"""
previous_pull_start_time = -2

"""
    Will track the time just before the Updater
    will try to update the origins
"""
curr_origin_up_start_time = -1

"""
    Will track the start time of the previous
    origin update
"""
previous_origin_up_start_time = -2

"""
    Will track the time just after the Updater
    will try to update the origins
"""
curr_origin_up_end_time = -1

"""
    Will track the end time of the previous
    origin update
"""
previous_origin_up_end_time = -2