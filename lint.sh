#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

shopt -s globstar nullglob

PATH=$PWD/node_modules/.bin:$PATH
REMARKRC=$PWD/.scripts/.remarkrc

failed=n

# Load environment variables from .env (if present)
# shellcheck disable=SC1091
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

cd ..

echo Linting Markdown...
if ! find . -name node_modules -prune -o -name .render -prune -o -name '*.md' -print0 | xargs -0 remark --rc-path "$REMARKRC" --frail; then
    failed=y
fi

if [ -d APIs ]; then
    echo Linting APIs...
    for i in APIs/*.raml; do
        perl -pi.bak -e 's/!include//' "$i"
        if yamllint "$i" > output; then
            echo "$i" ok
        else
            cat output
            echo -e "\033[31m$i failed\033[0m"
            failed=y
            rm output
        fi
        mv "$i.bak" "$i"
    done
fi

if [ -d APIs/schemas ]; then
    echo Linting schemas...
    for i in APIs/schemas/*.json ; do
        if jsonlint "$i" > /dev/null; then
            echo "$i" ok
        else
            echo -e "\033[31m$i failed\033[0m"
            failed=y
        fi
    done
fi

if [ -d examples ]; then
    echo Linting examples...
    for i in examples/**/*.json ; do
        if jsonlint "$i" > /dev/null; then
            echo "$i" ok
        else
            echo -e "\033[31m$i failed\033[0m"
            failed=y
        fi
    done
    for i in examples/**/*.sdp ; do
        # shellcheck disable=SC2086
        if sdpoker "$i" ${SDPOKER_OPTIONS:-}; then
            echo "$i" ok
        else
            echo -e "\033[31m$i failed\033[0m"
            failed=y
        fi
    done
fi

if [ "$failed" == "y" ]; then
    exit 1
else
    exit 0
fi
