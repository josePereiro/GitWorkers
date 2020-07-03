"""
    Look up in the dirtree for files. Returns true if any path
    makes fun returns true
    Signature:
        fun(path)::Bool
"""
exist_up(fun::Function, rootpath = pwd()) = !isnothing(find_up(fun, rootpath))