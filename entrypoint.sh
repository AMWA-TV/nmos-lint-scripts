#!/bin/bash -l

export PAGES_REPO_NWO="$GITHUB_REPOSITORY"
git clone --single-branch ${GITHUB_BRANCH:+--branch $GITHUB_BRANCH} "https://github.com/$GITHUB_REPOSITORY" /github-repo
cd /github-repo/.lint || exit
ln -s /.scripts .scripts
ln -s /node_modules node_modules
make lint
