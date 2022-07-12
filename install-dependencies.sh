#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

[ ! -e .scripts/package.json ] && echo Run this from the top-level directory && exit 1

cp .scripts/package.json .
yarn install
