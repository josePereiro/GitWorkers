function _readme(;
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