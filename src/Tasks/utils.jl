## ---------------------------------------------------------------
function _format_src(src)
    lines = split(src, "\n"; keepempty = false)
    for i in eachindex(lines)
        lines[i] = strip(lines[i], [' ', '\t', '\n'])
    end
    join(lines, "\n")
end

