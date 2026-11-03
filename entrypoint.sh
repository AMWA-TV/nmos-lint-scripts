#!/bin/bash -l

export PAGES_REPO_NWO="$GITHUB_REPOSITORY"
if [ -d .lint ]; then
    # Lint the repo mounted as the working directory
    echo "Linting $PWD"
    if [ -e .lint/.scripts ] || [ -e .lint/node_modules ]; then
        echo "Remove .lint/.scripts and .lint/node_modules first, e.g. with 'make distclean' in .lint"
        exit 1
    fi
    # The mounted files are not owned by the container user
    git config --global --add safe.directory '*'
else
    echo "GITHUB_REF is $GITHUB_REF"
    mkdir /github-repo
    cd /github-repo || exit
    git init --initial-branch=main
    git remote add origin "https://github.com/$GITHUB_REPOSITORY"
    git fetch --depth=1 origin "$GITHUB_REF"
    git -c advice.detachedHead=false checkout FETCH_HEAD
fi
cd .lint || exit
ln -s /.scripts .scripts
ln -s /node_modules node_modules
make lint
status=$?
rm .scripts node_modules
exit $status
