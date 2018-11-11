#!/usr/bin/env bash

SERVICE_NAME="plex"

chcek_return_code_of_last_command() {
	if [[ $1 != 0 ]]; then
		echo "Service '$SERVICE_NAME' is not running"
		exit $1
	fi
}

extract_env_variable() {
	echo "Detecting env variable $1..."
	eval temp=\$$1
	if [ -z "$temp" ]; then
		echo "Detected empty value... Setting to default: $2"
		temp="$2"
	fi
	echo "$1=$temp"
	eval $1=\"$temp\"
}

safe_create_folder() {
	if [ ! -d "$1" ]; then
		echo "Creating folder..."
		mkdir -p "$1"
		chcek_return_code_of_last_command $?
	fi

	abs_path="$( cd "$1" >/dev/null && pwd )"
	eval $2=\"$abs_path\"
}

echo "Detecting root dir of script..."
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
cd "$ROOT_DIR"
echo "Script folder: $PWD"

echo "Preparing environment for service '$SERVICE_NAME'"

extract_env_variable MEDIA_DIR media
safe_create_folder "$MEDIA_DIR" MEDIA_DIR
echo "TEST = $MEDIA_DIR"
exit 0

MEDIA_DIR=$( folder_from_env_variable MEDIA_DIR media )
echo "$MEDIA_DIR"
exit 0

echo "Detecting env variable MEDIA_DIR..."
if [ -z "$MEDIA_DIR" ]; then
	echo "Detected empty value... Setting to default: media"
	MEDIA_DIR="media"
fi
echo "MEDIA_DIR=$MEDIA_DIR"

if [ ! -d "$MEDIA_DIR" ]; then
	echo "Creating media folder..."
  mkdir -p "$MEDIA_DIR"
	chcek_return_code_of_last_command $?
fi

MEDIA_DIR="$( cd "$MEDIA_DIR" >/dev/null && pwd )"

echo "completed"

exit 0

echo "Run container with service '$SERVICE_NAME'"

# payload
docker run -d \
	--name=plex \
	--restart=always \
	--net=host \
	-v "$ROOT_DIR/config":/config \
	-v "$MEDIA_DIR":/data \
	-v "$ROOT_DIR/transcode":/transcode \
	-e PUID=1000 -e PGID=1000 \
	lsioarmhf/plex

chcek_return_code_of_last_command $?

echo "Service '$SERVICE_NAME' is running"
