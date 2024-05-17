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
    NEW_REPO_NAME=$1
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

# Make sure there's no lfs (TODO -- see
# https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository)
cd ${OLD_REPO_NAME}.git
ls_files=git lfs ls-files &> /dev/null
cd ..
if [[ ${ls_files} ]]; then
    GIT_LFS=1
else
    GIT_LFS=0
fi

if [[ ${GIT_LFS} == 1 ]]; then
    echo "Repo has git lfs and this is not yet supported. Exiting."
    exit 1
fi

# Create new repo on github
gh repo create ${NEW_REPO_NAME} --${GH_REPO_TYPE}

# Mirror-push
cd ${OLD_REPO_NAME}.git
git push --mirror git@github.com:${GH_USER}/${NEW_REPO_NAME}.git
cd ..

# If all is ok
# /usr/bin/rm -rf ${OLD_REPO_NAME}.git
