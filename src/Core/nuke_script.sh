# ---------------------------------------------------------------------------------------
# args 
if [ $# -lt 5 ]; then
	echo "Not enougth arguments."
	echo "Usage: sync_script <repodir> <url> <op_mode> <commit_msg> <success_token> <fail_token>"
	exit 1
fi

sh_repodir="$1" 
sh_url="$2" 
sh_depth="$3"
sh_success_token="$4" 
sh_error_token="$5" 

# verb
# echo ${sh_repodir}
# echo ${sh_url}
# echo ${sh_depth}
# echo ${sh_success_token}
# echo ${sh_error_token}

# ---------------------------------------------------------------------------------------
# variables 
sh_nuked_dummy="${sh_repodir}/.nuked" 
sh_gitignore="${sh_repodir}/.gitignore" 
sh_startup_file="${sh_repodir}/sync_startup"
sh_main_branch="$(git symbolic-ref --short  HEAD)"
sh_nuked_branch="nuked"
sh_remote="$(git remote)"

# ---------------------------------------------------------------------------------------
# startup 
[ -f "${sh_startup_file}" ] && source "${sh_startup_file}"

# ---------------------------------------------------------------------------------------
# utils 
_success () {
	echo "success token: ${sh_success_token}"
	exit 0
}
_error () { 
	local msg="$1"
	echo "error token: ${sh_error_token}"
	echo "error: ${msg}"
	rm -frd "${sh_repodir}" # force clone next time
	exit 1
}
_check_root () {
	local reporoot="$(git -C "${sh_repodir}" rev-parse --show-toplevel)"
	[ -d "${reporoot}" ] && [ "${reporoot}" != "${sh_repodir}" ] && _error "unexpected repo root"
	return 0
}

# ---------------------------------------------------------------------------------------
# check root
_check_root || _error "_check_root fails"

# ---------------------------------------------------------------------------------------
# pull hard
echo
echo "pulling hard"
git -C "${sh_repodir}" fetch || _error "git fetch failed" 
git -C "${sh_repodir}" reset --hard FETCH_HEAD || _error "git reset --hard FETCH_HEAD failed" 

# ---------------------------------------------------------------------------------------
# reduce repo
# TODO: Add rebase
# git -C "${sh_repodir}" checkout "HEAD~${depth}" || _error "git checkout "HEAD~${depth}" failed"
git -C "${sh_repodir}" checkout "HEAD" || _error "git checkout "HEAD~${depth}" failed"
git -C "${sh_repodir}" checkout --orphan "${sh_nuked_branch}" || _error "git checkout --orphan ${sh_nuked_branch} failed" 
rm -frd "${sh_gitignore}" || _error "rm -frd .gitignore"
echo "Nuked at $(date)" > ${sh_nuked_dummy}
git -C "${sh_repodir}" add -A || _error "git add -A failed"
echo "Commiting"
git -C "${sh_repodir}" commit -am "Boooom" || _error "git commit -am Boooom failed"
git -C "${sh_repodir}" branch -D "${sh_main_branch}" || _error "git branch -D ${sh_main_branch} failed"
git -C "${sh_repodir}" branch -m "${sh_main_branch}" || _error "branch -m ${sh_main_branch} failed"
git -C "${sh_repodir}" push --force "${sh_remote}" "${sh_main_branch}" || _error "push --force ${sh_remote} ${sh_main_branch} failed"
git -C "${sh_repodir}" gc || _error "gc failed"
