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

## ------------------------------------------------------------------
argset = ArgParse.ArgParseSettings()
ArgParse.@add_arg_table! argset begin
    "--sys-root"
        required=true
    "--url"
        required=true
end

parsed_args = ArgParse.parse_args(ARGS, argset)
sys_root = parsed_args["sys-root"]
url = parsed_args["url"]

## ------------------------------------------------------------------
GitWorkers._setup_gitworker_local_part(;url, sys_root)

## ------------------------------------------------------------------
# REG PROC
GitWorkers._reg_proc(getpid(); desc = "SERVER-LOOP")

## ------------------------------------------------------------------
GitWorkers._server_loop()