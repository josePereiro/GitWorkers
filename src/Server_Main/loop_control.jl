# ------------------------------------------------------
# WAIT TIME
# mins from reset => wait time
const _GW_SERVER_MAIN_SLEEP_PROGRAM = SleepProgram(60 => 2, 2*60 => 15, 10*60 => 60, 30*60 => 3*60)

_reset_server_main_listen_wait() = reset!(_GW_SERVER_MAIN_SLEEP_PROGRAM)

function _server_main_listen_wait()
    println("\nJust listening, time: ", now())
    sleep(_GW_SERVER_MAIN_SLEEP_PROGRAM)
end