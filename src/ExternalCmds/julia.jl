function julia(file;
        verb::Bool = false
    )
    _run(`$(Base.julia_cmd()) --startup-file=no $(file)`; verb)
end