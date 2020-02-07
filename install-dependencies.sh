#!/bin/bash

set -o errexit

[ ! -e .scripts/package.json ] && echo Run this from the top-level directory && exit 1

cp .scripts/package.json .
yarn install
