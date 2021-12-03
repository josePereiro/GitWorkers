abstract type AbstractGWRegistry end

import Base.get!
get!(f::Function, r::AbstractGWRegistry, key) = get!(f, r.dat, key)
get!(r::AbstractGWRegistry, key, val) = get!(r.dat, key, val)

import Base.get
get(f::Function, r::AbstractGWRegistry, key) = get(f, r.dat, key)
get(r::AbstractGWRegistry, key, val) = get(r.dat, key, val)

set!(r::AbstractGWRegistry, key, val) = (r.dat[key] = val)
set!(f::Function, r::AbstractGWRegistry, key) = (r.dat[key] = f())