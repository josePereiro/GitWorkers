# ---------------------------------------------------------------------------------------
# args 
if [ $# -lt 6 ]; then
	echo "Not enougth arguments."
	echo "Usage: sync_script <repodir> <url> <op_mode> <commit_msg> <success_token> <fail_token>"
	exit 1
fi
sh_repodir="$1" 
sh_url="$2" 
sh_op_mode="$3" 
sh_commit_msg="$4" 
sh_success_token="$5" 
sh_fail_token="$6" 

# deb
# echo ${sh_repodir}
# echo ${sh_url}
# echo ${sh_op_mode}
# echo ${sh_commit_msg}
# echo ${sh_success_token}
# echo ${sh_fail_token}

# ---------------------------------------------------------------------------------------
# variables 
sh_repodir_git="${sh_repodir}/.git" 
sh_gitignore="${sh_repodir}/.gitignore" 
sh_recovery_dir="${sh_repodir}/.recovery" 
sh_recovery_dir_git="${sh_recovery_dir}/.git" 
sh_startup_file="${sh_repodir}/sync_startup" 

# ---------------------------------------------------------------------------------------
# startup 
[ -f "${sh_startup_file}" ] && source "${sh_startup_file}"

# ---------------------------------------------------------------------------------------
# utils 
_success () {
	echo "success token: ${sh_success_token}"
	rm -frd "${sh_recovery_dir}" # clear recoveri_dir
	exit 0
}
_error () { 
	echo "error token: ${sh_error_token}"
	echo "error: $1"
	rm -frd "${sh_repodir_git}" # force clone next time
	rm -frd "${sh_recovery_dir}" # clear recoveri_dir
	exit
}
_check_root () {
	local reporoot="$(git -C "${sh_repodir}" rev-parse --show-toplevel)"
	[ -d "${reporoot}" ] && [ "${reporoot}" != "${sh_repodir}" ] && _error "unexpected repo root"
	return 0
}
_is_force_clone_mode () {
	[ "${sh_op_mode}" = "FORCE_CLONE" ] && return 0
	[ "${sh_op_mode}" = "FORCE_CLONE_AND_PUSH" ] && return 0
	return 1
}
_is_pull_mode () {
	local op_mode=$1
	[ "${sh_op_mode}" = "PULL_OR_CLONE" ] && return 0
	[ "${sh_op_mode}" = "PULL_OR_CLONE_AND_PUSH" ] && return 0
	[ "${sh_op_mode}" = "FORCE_CLONE" ] && return 0
	return 1
}
_is_push_mode () {
	local op_mode=$1
	[ "${sh_op_mode}" = "FORCE_CLONE_AND_PUSH" ] && return 0
	[ "${sh_op_mode}" = "PUSH" ] && return 0
	return 1
}

# ---------------------------------------------------------------------------------------
# go to root 
mkdir -p "${sh_repodir}" || _error "unable to create repo dir" 
cd "${sh_repodir}" || _error "unable to cd repo dir" 

# ---------------------------------------------------------------------------------------
# pull or clonne if necesary 
_is_force_clone_mode && rm -frd "${sh_repodir_git}" 
if _is_pull_mode; then
	_check_root || _error "_check_root fails" 
	if [ ! -d "${sh_repodir_git}" ]; then
		echo
		echo "clonning repo"
		mkdir -p "${sh_recovery_dir}" || _error "unable to create recovery dir" 
		git -C "${sh_repodir}" clone --depth=1 "${sh_url}" "${sh_recovery_dir}" || _error "git clone failed" 
		mv -f "${sh_recovery_dir_git}" "${sh_repodir_git}" || _error "recovery copy failed" 
	fi
	echo
	echo "pulling hard"
	git -C "${sh_repodir}" fetch || _error "git fetch failed" 
	git -C "${sh_repodir}" reset --hard FETCH_HEAD || _error "git reset --hard FETCH_HEAD failed" 
fi
[ "$?" != "0" ] && _error "PULL or CLONE fails"

# ---------------------------------------------------------------------------------------
# clear recovery_dir
rm -frd "${sh_recovery_dir}" || _error "at rm -frd recovery_dir" 

# ---------------------------------------------------------------------------------------
# push 
if _is_push_mode; then
	echo
	echo "soft pushing"
	_check_root || _error "_check_root fails" 
	[ -f "${sh_gitignore}" ] || _error ".gitignore missing" 
	git -C "${sh_repodir}" add -A || _error "add -A failed" 
	git -C "${sh_repodir}" status || _error 
	git -C "${sh_repodir}" diff-index --quiet HEAD && _success # If nothing to commit _success
	git -C "${sh_repodir}" commit -am "${sh_commit_msg}" || _error "commit -am 'msg' failed" 
	git -C "${sh_repodir}" push || _error "git push failed" 
fi
[ "$?" != "0" ] && _error "PUSH fails"

# ---------------------------------------------------------------------------------------
# success 
_success