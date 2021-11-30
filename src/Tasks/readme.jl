const _GW_TASK_README_FILE_NAME = "README.md"
_readme_file(taskdir::String) = joinpath(taskdir, _GW_TASK_README_FILE_NAME)

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
function _gen_readme(taskdir::String)
    
    tfile = _task_file(taskdir)
    tdict = _read_toml(tfile)

    dat_file = _taskdat_file(taskdir)

    txt = _readme_txt(; tid, src, desc, lang)
    mdfile = _readme_file(taskdir)
    write(mdfile, readme)
end