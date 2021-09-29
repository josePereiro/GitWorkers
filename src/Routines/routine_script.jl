## ------------------------------------------------------------------
function _save_import(pkg_str::String)
    @eval try
        import $(Symbol(pkg_str))
    catch err
        import Pkg
        Pkg.add($(pkg_str))
        import $(Symbol(pkg_str))
    end
end

## ------------------------------------------------------------------
_save_import("GitWorkers")
import GitWorkers.ArgParse
_save_import("Serialization")

## ------------------------------------------------------------------
_rtargset = ArgParse.ArgParseSettings()
ArgParse.@add_arg_table! _rtargset begin
    "sys-root"
        required=true
    "url"
        required=true
    "rtfile"
        required=true
    "rtid"
        required=true
end

parsed_args = ArgParse.parse_args(ARGS, _rtargset)
_rtid = parsed_args["rtid"]
_rtfile = parsed_args["rtfile"]
_sys_root = parsed_args["sys-root"]
_url = parsed_args["url"]

## ------------------------------------------------------------------
GitWorkers._setup_gitworker_local_part(;url = _url, sys_root = _sys_root)

## ------------------------------------------------------------------
# REG PROC
GitWorkers._reg_proc(getpid(); desc = _rtid)

## ------------------------------------------------------------------
# flush helps
_gw_isrunning = true
@async while _gw_isrunning
    flush(stdout)
    flush(stderr)
    sleep(5.0)
end

## ------------------------------------------------------------------
# WELCOME
println("\n STARTING ----------------------------------")
println("pid: ", getpid())
println("task id: ", _rtid)
println("\n\n")

## ------------------------------------------------------------------
# eval expr
_rtcmd = Serialization.deserialize(_rtfile)
@sync GitWorkers.eval(_rtcmd.expr)

## ------------------------------------------------------------------
_gw_isrunning = false

## ------------------------------------------------------------------
# FINISHED
println("\n FINISHED ----------------------------------")
println("pid: ", getpid())
println("task id: ", _rtid)
println("\n\n")

## ------------------------------------------------------------------
# insist
for _ in 1:10
    flush(stdout)
    flush(stderr)
end

## ------------------------------------------------------------------
exit()