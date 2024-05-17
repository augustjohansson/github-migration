#!/bin/bash
# https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository
# https://cli.github.com/manual/gh_repo_create

OLD_REPO_NAME=$1
if [[ $# -eq 2 ]]; then
    NEW_REPO_NAME=$2
else
    NEW_REPO_NAME=$1
fi

BB_USER=augustjohansson
GH_USER=augustjohansson

# Create new repo on github using gh cli
gh repo create ${NEW_REPO_NAME} --private

# Create bare clone
git clone --mirror https://bitbucket.org/${BBUSER}/${OLD_REPO_NAME}.git

exit 1

# Mirror-push
cd ${OLD_REPO_NAME}.git
git push --mirror https://github.com/${GH_USER}/${NEW_REPO_NAME}.git

# If all is ok...
cd .. && rm -rf ${OLD_REPO_NAME}.git
