#!/bin/bash -l

export PAGES_REPO_NWO="$GITHUB_REPOSITORY"
echo "GITHUB_REF is $GITHUB_REF"
mkdir /github-repo
cd /github-repo || exit
git init --initial-branch=main
git remote add origin "https://github.com/$GITHUB_REPOSITORY"
git fetch --depth=1 origin "$GITHUB_REF"
git checkout FETCH_HEAD
cd .lint || exit
ln -s /.scripts .scripts
ln -s /node_modules node_modules
make lint
