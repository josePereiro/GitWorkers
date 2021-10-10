# using Dates

# ## ------------------------------------------------------------------------
# let
#     ## ------------------------------------------------------------------------
#     depth = 5
#     nuked_dir = "/Users/Pereiro/.gitworker/nuked"
#     url = "https://github.com/josePereiro/Example.jl"

#     # git config receive.denyNonFastForwards false

#     ## ------------------------------------------------------------------------
#     # clonning
#     rm(nuked_dir; force = true, recursive = true)
#     mkpath(nuked_dir)
#     cmd_arr = string.(["git", "-C", nuked_dir, "clone", url, nuked_dir])
#     run(Cmd(cmd_arr); wait = true)

#     ## ------------------------------------------------------------------------
#     # commiting shit
#     for name in readdir(nuked_dir)
#         path = joinpath(nuked_dir, name)
#         isfile(path) && rm(path; force = true)
#     end

#     for it in 1:10
#         blob = string("bloob", it)
#         touch(joinpath(nuked_dir, blob))
#         run(Cmd(string.(
#             ["git", "-C", nuked_dir, "add", "-A"]
#         )); wait=true)
        
#         run(Cmd(string.(
#             ["git", "-C", nuked_dir, "commit", "-am", blob]
#         )); wait=true)
#     end
#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "push", "--force"]
#     )); wait=true)

#     ## ------------------------------------------------------------------------
#     # log
#     println("\n"^3)
#     cmd_arr = string.(["git", "-C", nuked_dir, "--no-pager", "log", "--decorate=short", "--pretty=oneline", "-n10"])
#     run(Cmd(cmd_arr); wait = true)
    
#     ## ------------------------------------------------------------------------
#     # reduce repo
#     println("\n"^3)
#     temp_b = "nucked"
#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "checkout", "HEAD~$(depth)"]
#     )); wait=true)

#     temp_b = "nucked"
#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "checkout", "--orphan", temp_b]
#     )); wait=true)

#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "add", "-A"]
#     )); wait=true)

#     msg = "Nucked at $(now())"
#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "commit", "-am", msg]
#     )); wait=true)

#     target_b = "master"
#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "branch", "-D", target_b]
#     )); wait=true)
    
#     # run(Cmd(string.(
#     #     ["git", "-C", nuked_dir, "push", "origin", "--delete", target_b]
#     # )); wait=true)

#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "branch", "-m", target_b]
#     )); wait=true)

#     run(Cmd(string.(
#         ["git", "-C", nuked_dir, "push", "--force", "origin", target_b]
#     )); wait=true)

#     run(Cmd(string.(
#         # ["git", "-C", nuked_dir, "gc", "—-aggressive", "--prune=now"]
#         ["git", "-C", nuked_dir, "gc"]
#     )); wait=true)

#     ## ------------------------------------------------------------------------
#     # re-clonning
#     println("\n"^3)
#     rm(nuked_dir; force = true, recursive = true)
#     mkpath(nuked_dir)
#     cmd_arr = string.(["git", "-C", nuked_dir, "clone", url, nuked_dir])
#     run(Cmd(cmd_arr); wait = true)

#     ## ------------------------------------------------------------------------
#     # log
#     println("\n"^3)
#     cmd_arr = string.(["git", "-C", nuked_dir, "--no-pager", "log", "--decorate=short", "--pretty=oneline", "-n10"])
#     run(Cmd(cmd_arr); wait = true)

#     nothing
# end