const _GW_TASK_DAT_FILE_NAME = "dat.jls"
_taskdat_file(taskdir::String) = joinpath(taskdir, _GW_TASK_DAT_FILE_NAME)
_taskdat_file(gwt::GWTask) = _taskdat_file(task_dir(gwt))

const _GW_TASK_EXPR_KEY = "expr"
const _GW_TASK_SRC_KEY = "src"
const _GW_TASK_DESC_KEY = "desc"
const _GW_TASK_LANG_KEY = "lang"

_task_dat(gwt::GWTask) = get!(gwt, _GW_TASK_FILE_NAME) do
    Dict{String, Any}()
end

function _write_task_dat!(gwt::GWTask; ex, src, desc, lang)

    dfile = _taskdat_file(gwt)
    dat = _task_dat(gwt)
    dat[_GW_TASK_EXPR_KEY] = ex
    dat[_GW_TASK_SRC_KEY] = src
    dat[_GW_TASK_DESC_KEY] = desc
    dat[_GW_TASK_LANG_KEY] = lang
    serialize(dfile, dat)

    return dat
end

function _read_task_dat!(gwt::GWTask)

    tfile = _taskdat_file(gwt)
    dat = deserialize(tfile)
    merge!(_task_toml(gwt), dat)
    
    return toml
end

function _task_desc(gwt::GWTask)
    dat = _task_dat(gwt)
    get!(dat, _GW_TASK_DESC_KEY, "")
end

function _task_expr(gwt::GWTask)
    dat = _task_dat(gwt)
    get!(dat, _GW_TASK_EXPR_KEY, :(nothing))
end

function _task_src(gwt::GWTask)
    dat = _task_dat(gwt)
    get!(() -> _expr_src(gwt), dat, _GW_TASK_SRC_KEY)
end

function _task_lang(gwt::GWTask)
    dat = _task_dat(gwt)
    get!(dat, _GW_TASK_LANG_KEY, "")
end