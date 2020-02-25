#!/bin/sh

# NOTE: this command must be called with 

set -x

if [ -z "$1" ]; then
  echo "Missing Environment Choice. It must be local, prod or dev"
else
  echo "Environment Variable passed: $1"
  CONF="$1"
fi

source ${PWD}/repo_paths.sh

FOLDER_DOCKER_LOGS=$PATH_CODE/logs

if [ -f $PATH_REPO/docker-compose.override.yml ]; then rm $PATH_REPO/docker-compose.override.yml; fi
if [ -f $PATH_REPO/.env ]; then rm $PATH_REPO/.env; fi

ln -s $PATH_REPO/.env.$CONF $PATH_REPO/.env
if [ -f $PATH_REPO/docker-compose.override.yml.$CONF ]; then ln -s $PATH_REPO/docker-compose.override.yml.$CONF $PATH_REPO/docker-compose.override.yml; fi


