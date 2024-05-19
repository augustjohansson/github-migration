#!/bin/bash
# Script for moving repo from bitbucket to github
#
# This script is based on:
# https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository
# https://cli.github.com/manual/gh_repo_create
# https://stackoverflow.com/questions/6569478/detect-if-executable-file-is-on-users-path/53798785#53798785
#
# It needs git lfs and gh

# Get repo names
OLD_REPO_NAME=$1
if [[ $# == 2 ]]; then
    NEW_REPO_NAME=$2
else
    NEW_REPO_NAME=${OLD_REPO_NAME}
fi

# User names
BB_USER=augustjohansson
GH_USER=augustjohansson

# Private/public/internal gh repo?
GH_REPO_TYPE=private

# Check for gh and git-lfs
function check_command() {
    has_command=builtin type -P "$1" &> /dev/null
    if [[ -n ${has_command} ]]; then
	echo "$1 not found"
	exit 1
    fi
}
check_command gh
check_command git-lfs

# Create bare clone
git clone --mirror git@bitbucket.org:${BB_USER}/${OLD_REPO_NAME}.git

# Check for git lfs files (NB: bare repo here)
cd ${OLD_REPO_NAME}.git
lfs_files=`git lfs ls-files`
cd ..

if [[ ${lfs_files} ]]; then
    # Fetch git lfs
    cd ${OLD_REPO_NAME}.git
    git lfs fetch --all
    cd ..
fi

# Create new repo on github
gh repo create ${NEW_REPO_NAME} --${GH_REPO_TYPE}

# Mirror-push
cd ${OLD_REPO_NAME}.git
git push --mirror git@github.com:${GH_USER}/${NEW_REPO_NAME}.git
cd ..

if [[ ${lfs_files} ]]; then
    cd ${OLD_REPO_NAME}.git
    git lfs push --all git@github.com:${GH_USER}/${NEW_REPO_NAME}.git
    cd ..
fi

# If all is ok
# /usr/bin/rm -rf ${OLD_REPO_NAME}.git
