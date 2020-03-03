#!/bin/sh

# NOTE: this command must be called with 

set -x

source ${PWD}/repo_paths.sh

PATH_VOLUME=$PATH_REPO/volumes
PATH_MONICA=$PATH_VOLUME/monica_celery
PATH_WEB=$PATH_VOLUME/web

declare -a array_file_cleanup=("$PATH_MONICA/var/run/celery/beat-schedule.db")

docker container prune -f
docker volume prune -f

for file_cleanup in "${array_file_cleanup[@]}"
	do
		if [ -f $file_cleanup ]; then rm -f $file_cleanup; fi
	done

declare -a array_folder_cleanup=("$PATH_MONICA/logs" "$PATH_WEB/logs")

for folder_cleanup in "${array_folder_cleanup[@]}"
	do
		if [ -d $folder_cleanup ]; then rm -f $folder_cleanup/*; fi
	done


