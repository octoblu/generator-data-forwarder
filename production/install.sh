#!/usr/bin/env bash
cd $(dirname $0)
set -eE
PRODUCTION_ENV_DIR=~/Projects/Octoblu/the-stack-env-production
rsync -avh --progress ./deployment-files/* $PRODUCTION_ENV_DIR


npm i -g deployinate-configurator

dplcfg service generator-data-forwarder -d service-files

STACK_SERVICES_DIR=~/Projects/Octoblu/the-stack-services/services.d/generator-data-forwarder
rsync -avh --progress ./service-files/* $STACK_SERVICES_DIR

echo "\n\n\n"

echo "Alright, I'm not going to do the rest for you, because I could be wrong and it could be dangerous. But you need to:"

echo "get octoblu/tools from brew if you don't have them"

echo "run 'minorsync load generator-data-forwarder'"
echo "run 'majorsync load generator-data-forwarder'"

echo "run 'fleetctl submit $STACK_SERVICES_DIR/*.service'"

echo "commit the changes to the-stack-env-production"
echo "commit the changes to the-stack-services"
