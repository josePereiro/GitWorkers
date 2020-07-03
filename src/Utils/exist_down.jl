"""
    Look down in the dirtree for files. Returns true if any path
    makes fun returns true
    Signature:
        fun(path)::Bool
"""
exist_down(fun::Function, rootpath = pwd()) = !isnothing(find_down(fun, rootpath))