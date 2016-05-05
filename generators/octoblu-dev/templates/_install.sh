#!/usr/bin/env bash
cd $(dirname $0)
set -eE
OCTOBLU_DEV_DIR=~/Projects/Octoblu/octoblu-dev
rsync -avh --progress ./deployment-files/* $OCTOBLU_DEV_DIR
$OCTOBLU_DEV_DIR/generator/bin/generate-all.sh
