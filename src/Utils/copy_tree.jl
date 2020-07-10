"""
    Copy a tree one file at a time, alowing to 
    execute `oncopy` function everytime a 
    non-error copy is executed. Also, passing `onerr`
    allow to handle the errors one file at the time. `filterfun`
    allow to control which paths to copy.
    signatures/default:
        filterfun = (path) -> true
        oncopy = (srcfile, destfile) -> nothing,
        onerr = (srcfile, destfile, err) -> rethrow(err)
"""
function copy_tree(srcroot, destroot; 
        filterfun = (path) -> true, 
        follow_symlinks = true,
        force = true,
        oncopy = (srcfile, destfile) -> nothing,
        onerr = (srcfile, destfile, err) -> rethrow(err))

    for (srcdir, dirs , srcfiles) in walkdir(srcroot)
        !filterfun(srcdir) && continue
        destdir = replace(srcdir, srcroot => destroot)
        mkpath(destdir)
        
        for file in srcfiles
            srcfile = joinpath(srcdir, file)
            !filterfun(srcfile) && continue
            destfile = joinpath(destdir, file)
            try
                cp(srcfile, destfile, force = true)
            catch err
                onerr(srcfile, destfile, err)
            end
            oncopy(srcfile, destfile)
        end
    end
    
end