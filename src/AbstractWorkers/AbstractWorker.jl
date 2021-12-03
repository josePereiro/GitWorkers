abstract type AbstractWorker end

import Base.get!
get!(f::Function, w::AbstractWorker, key) = get!(f, w.dat, key)
get!(w::AbstractWorker, key, val) = get!(w.dat, key, val)

import Base.get
get(f::Function, w::AbstractWorker, key) = get(f, w.dat, key)
get(w::AbstractWorker, key, val) = get(w.dat, key, val)

set!(w::AbstractWorker, key, val) = (w.dat[key] = val)
set!(f::Function, w::AbstractWorker, key) = (w.dat[key] = f())