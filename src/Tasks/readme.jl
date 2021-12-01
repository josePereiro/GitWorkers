const _GW_TASK_README_FILE_NAME = "README.md"
_readme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_README_FILE_NAME)
_readme_file(gwt::GWTask) = _readme_file(task_dir(gwt))

function _readme_txt(;
        tid, src, desc, lang,
    )
    return string(
        "# ", tid, "\n\n",
        desc, "\n\n",
        "## Usage", "\n\n",
        "- Run `runme.jl` for a full reproduction", "\n",
        "- Check `out.log` for last run output", "\n",
        "- Check `run.log` for run history", "\n",
        "\n",
        "## Source code", "\n\n",
        "```", lang, "\n",
        src, "\n",
        "```", 
        "\n"
    )
end

# gen a readme from task data
function _do_readme!(gwt::GWTask)
    readme = _readme_txt(; 
        tid  = task_id(gwt), 
        src = _task_src(gwt), 
        desc = _task_desc(gwt), 
        lang = _task_lang(gwt)
    )
    mdfile = _readme_file(gwt)
    write(mdfile, readme)
end