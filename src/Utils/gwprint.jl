"""
    This just print the stuff in both, the given file and
    the global std buffer
"""
gwprint(ios::Vector, args...) = foreach((io) -> Base.print(io, args...), ios)
gwprintln(ios::Vector, args...) = gwprint(ios::Vector, args..., "\n")
